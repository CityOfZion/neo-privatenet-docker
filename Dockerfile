# NEO private network - Dockerfile

FROM microsoft/dotnet:2.0-runtime
LABEL maintainer="City of Zion"
LABEL authors="hal0x2328, phetter, metachris, ashant"

ENV DEBIAN_FRONTEND noninteractive

# Disable dotnet usage information collection
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    unzip \
    screen \
    expect \
    libleveldb-dev \
    git-core \
    python3.5-dev python3-pip libssl-dev

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# neo-python setup
RUN git clone https://github.com/CityOfZion/neo-python.git /opt/neo-python
RUN cd /opt/neo-python && git checkout origin/master
RUN pip3 install -r /opt/neo-python/requirements.txt

# Add the neo-cli package
ADD ./neo-cli.zip /opt/neo-cli.zip

# Extract and prepare four consensus nodes
RUN unzip -q -d /opt/node1 /opt/neo-cli.zip
RUN unzip -q -d /opt/node2 /opt/neo-cli.zip
RUN unzip -q -d /opt/node3 /opt/neo-cli.zip
RUN unzip -q -d /opt/node4 /opt/neo-cli.zip

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
ADD ./scripts/run.sh /opt/
ADD ./scripts/start_consensus_node.sh /opt/
ADD ./scripts/claim_neo_and_gas.py /opt/neo-python/

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
