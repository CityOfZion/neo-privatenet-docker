#!/usr/bin/env python3
"""
This script claims all currently available the gas from the privatenet wallet.
"""

import os
import sys
import json
import time
import datetime
import argparse

from tempfile import NamedTemporaryFile
from Crypto import Random

from neo.Wallets.utils import to_aes_key
from neo.Implementations.Wallets.peewee.UserWallet import UserWallet
from neo.Implementations.Blockchains.LevelDB.LevelDBBlockchain import LevelDBBlockchain
from neocore.KeyPair import KeyPair
from neo.Prompt.Commands.LoadSmartContract import ImportMultiSigContractAddr
from neo.Core.Blockchain import Blockchain
from neocore.Fixed8 import Fixed8
from neo.Prompt.Commands.Send import construct_and_send
from neo.Prompt.Commands.Wallet import ClaimGas
from neo.Core.TX.Transaction import TransactionOutput, ContractTransaction
from neo.SmartContract.ContractParameterContext import ContractParametersContext
from neo.Network.NodeLeader import NodeLeader
from twisted.internet import reactor, task
from neo.Settings import settings

WALLET_PATH = "/tmp/privnet1"
WALLET_PWD = "neo"
MINUTES_TO_WAIT_UNTIL_GAS_CLAIM = 1


class PrivnetClaimall(object):
    start_height = None
    start_dt = None
    _walletdb_loop = None

    wallet_fn = None
    wallet_pwd = None
    min_wait = None

    def __init__(self, wallet_fn, wallet_pwd, min_wait):
        self.wallet_fn = wallet_fn
        self.wallet_pwd = wallet_pwd
        self.min_wait = min_wait

        self.start_height = Blockchain.Default().Height
        self.start_dt = datetime.datetime.utcnow()

    def quit(self):
        print('Shutting down.  This may take a bit...')
        self.go_on = False
        Blockchain.Default().Dispose()
        reactor.stop()
        NodeLeader.Instance().Shutdown()

    @staticmethod
    def send_neo(wallet, address_from, address_to, amount):
        assetId = None

        assetId = Blockchain.Default().SystemShare().Hash

        scripthash_to = wallet.ToScriptHash(address_to)
        scripthash_from = wallet.ToScriptHash(address_from)

        f8amount = Fixed8.TryParse(amount)

        if f8amount.value % pow(10, 8 - Blockchain.Default().GetAssetState(assetId.ToBytes()).Precision) != 0:
            raise Exception("incorrect amount precision")

        fee = Fixed8.Zero()

        output = TransactionOutput(AssetId=assetId, Value=f8amount, script_hash=scripthash_to)
        tx = ContractTransaction(outputs=[output])
        ttx = wallet.MakeTransaction(tx=tx, change_address=None, fee=fee, from_addr=scripthash_from)

        if ttx is None:
            raise Exception("insufficient funds, were funds already moved from multi-sig contract?")

        context = ContractParametersContext(tx, isMultiSig=True)
        wallet.Sign(context)

        if context.Completed:
            raise Exception("Something went wrong, multi-sig transaction failed")

        else:
            print("Transaction initiated")
            return json.dumps(context.ToJson(), separators=(',', ':'))

    def wait_for_tx(self, tx, max_seconds=300):
        """ Wait for tx to show up on blockchain """
        foundtx = False
        sec_passed = 0
        while not foundtx and sec_passed < max_seconds:
            _tx, height = Blockchain.Default().GetTransaction(tx.Hash)
            if height > -1:
                foundtx = True
                continue
            print("Waiting for tx {} to show up on blockchain...".format(tx.Hash.ToString()))
            time.sleep(3)
            sec_passed += 3
        if foundtx:
            return True
        else:
            print("Transaction was relayed but never accepted by consensus node")
            return False

    def run(self):
        dbloop = task.LoopingCall(Blockchain.Default().PersistBlocks)
        dbloop.start(.1)
        Blockchain.Default().PersistBlocks()

        while Blockchain.Default().Height < 2:
            print("Waiting for chain to sync...")
            time.sleep(1)

        # Open wallet again
        print("Opening wallet %s" % self.wallet_fn)
        self.wallet = UserWallet.Open(self.wallet_fn, to_aes_key("coz"))
        self.wallet.ProcessBlocks()
        self._walletdb_loop = task.LoopingCall(self.wallet.ProcessBlocks)
        self._walletdb_loop.start(1)

        print("\nWait %s min before claiming GAS." % self.min_wait)
        time.sleep(60 * self.min_wait)

        self.wallet.Rebuild()
        print("\nRebuilding wallet...")
        time.sleep(20)

        print("\nSending NEO to own wallet...")
        address = "AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y"
        tx = construct_and_send(None, self.wallet, ["neo", address, "100000000"], prompt_password=False)
        if not tx:
            print("Something went wrong, no tx.")
            return

        # Wait until transaction is on blockchain
        self.wait_for_tx(tx)

        print("Claiming the GAS...")
        claim_tx, relayed = ClaimGas(self.wallet, require_password=False)
        self.wait_for_tx(claim_tx)

        # Finally, need to rebuild the wallet
        # self.wallet.Rebuild()
        self.quit()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    args = parser.parse_args()

    settings.setup_privnet()
    print("Blockchain DB path:", settings.chain_leveldb_path)

    blockchain = LevelDBBlockchain(settings.chain_leveldb_path)
    Blockchain.RegisterBlockchain(blockchain)

    reactor.suggestThreadPoolSize(15)
    NodeLeader.Instance().Start()

    pc = PrivnetClaimall("/tmp/wallet", "coz", 1)
    reactor.callInThread(pc.run)
    reactor.run()
