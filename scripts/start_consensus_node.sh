#!/usr/bin/expect -f
set dnpath [lindex $argv 0]
set timeout -1
cd $dnpath
spawn dotnet neo-cli.dll --rpc
expect "neo>"
interact
