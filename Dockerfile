# NEO private network - Dockerfile
FROM microsoft/dotnet:2.1.4-runtime-bionic

LABEL maintainer="City of Zion"
LABEL authors="metachris, ashant, hal0x2328, phetter"

ENV DEBIAN_FRONTEND noninteractive

# Disable dotnet usage information collection
# https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry#behavior
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    unzip \
    screen \
    expect \
    libleveldb-dev \
    git-core \
    wget \
    curl \
    git-core \
    python3.6 \
    python3.6-dev \
    python3.6-venv \
    python3-pip \
    libleveldb-dev \
    libssl-dev \
    vim \
    man \
    libunwind8

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# neo-python setup: clonse and install dependencies
RUN git clone https://github.com/CityOfZion/neo-python.git /neo-python
WORKDIR /neo-python
# RUN git checkout development
RUN pip3 install -e .

# Add the neo-cli package
ADD ./neo-cli.zip /opt/neo-cli.zip
ADD ./SimplePolicy.zip /opt/SimplePolicy.zip
ADD ./ApplicationLogs.zip /opt/ApplicationLogs.zip 

# Extract and prepare four consensus nodes
RUN unzip -q -d /opt/node1 /opt/neo-cli.zip
RUN unzip -q -d /opt/node2 /opt/neo-cli.zip
RUN unzip -q -d /opt/node3 /opt/neo-cli.zip
RUN unzip -q -d /opt/node4 /opt/neo-cli.zip

# Extract and prepare SimplePolicy plugin
RUN unzip -q -d /opt/node1/neo-cli /opt/SimplePolicy.zip
RUN unzip -q -d /opt/node2/neo-cli /opt/SimplePolicy.zip
RUN unzip -q -d /opt/node3/neo-cli /opt/SimplePolicy.zip
RUN unzip -q -d /opt/node4/neo-cli /opt/SimplePolicy.zip

# Extract and prepare SimplePolicy plugin
RUN unzip -q -d /opt/node1/neo-cli /opt/ApplicationLogs.zip
RUN unzip -q -d /opt/node2/neo-cli /opt/ApplicationLogs.zip
RUN unzip -q -d /opt/node3/neo-cli /opt/ApplicationLogs.zip
RUN unzip -q -d /opt/node4/neo-cli /opt/ApplicationLogs.zip

# Remove zip neo-cli package
RUN rm /opt/neo-cli.zip
RUN rm /opt/SimplePolicy.zip
RUN rm /opt/ApplicationLogs.zip

# Add config files
ADD ./configs/config1.json /opt/node1/neo-cli/config.json
ADD ./configs/protocol.json /opt/node1/neo-cli/protocol.json
ADD ./wallets/wallet1.json /opt/node1/neo-cli/

ADD ./configs/config2.json /opt/node2/neo-cli/config.json
ADD ./configs/protocol.json /opt/node2/neo-cli/protocol.json
ADD ./wallets/wallet2.json /opt/node2/neo-cli/

ADD ./configs/config3.json /opt/node3/neo-cli/config.json
ADD ./configs/protocol.json /opt/node3/neo-cli/protocol.json
ADD ./wallets/wallet3.json /opt/node3/neo-cli/

ADD ./configs/config4.json /opt/node4/neo-cli/config.json
ADD ./configs/protocol.json /opt/node4/neo-cli/protocol.json
ADD ./wallets/wallet4.json /opt/node4/neo-cli/

# Add scripts
RUN wget https://s3.amazonaws.com/neo-experiments/neo-privnet.wallet
ADD ./scripts/run.sh /opt/
ADD ./scripts/start_consensus_node.sh /opt/
ADD ./scripts/claim_neo_and_gas_fixedwallet.py /neo-python/
ADD ./scripts/claim_gas_fixedwallet.py /neo-python/
ADD ./wallets/neo-privnet.python-wallet /tmp/wallet

# Some .bashrc helpers: 'neopy', and a welcome message for bash users
RUN echo "alias neopy=\"cd /neo-python && np-prompt -p\"" >> /root/.bashrc
RUN echo "printf \"\n* Consensus nodes are running in screen sessions, check 'screen -ls'\"" >> /root/.bashrc
RUN echo "printf \"\n* neo-python is installed in /neo-python, with a neo-privnet.wallet file in place\"" >> /root/.bashrc
RUN echo "printf \"\n* You can use the alias 'neopy' in the shell to start neo-python's prompt.py with privnet settings\"" >> /root/.bashrc
RUN echo "printf \"\n* Please report issues to https://github.com/CityOfZion/neo-privatenet-docker\n\n\"" >> /root/.bashrc

# Inform Docker what ports to expose
EXPOSE 20333
EXPOSE 20334
EXPOSE 20335
EXPOSE 20336

EXPOSE 30333
EXPOSE 30334
EXPOSE 30335
EXPOSE 30336

# On docker run, start the consensus nodes
CMD ["/bin/bash", "/opt/run.sh"]
