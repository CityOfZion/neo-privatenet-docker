# NEO private network - Dockerfile

FROM ubuntu:16.04
LABEL maintainer="hal0x2328"

ENV DEBIAN_FRONTEND noninteractive

# Disable dotnet usage information collection
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    apt-utils \
    mininet netcat curl wget unzip less python screen \
    ca-certificates apt-transport-https \
    libleveldb-dev sqlite3 libsqlite3-dev \
    expect \
    git-core python3.5-dev python3-pip libssl-dev

# Add dotnet apt repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list

# Install dotnet sdk
RUN apt-get update && apt-get install -y dotnet-sdk-2.0.0

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*

ADD ./neo-cli.zip /opt/neo-cli.zip

# Extract and prepare four consensus nodes
RUN unzip -d /opt/node1 /opt/neo-cli.zip
RUN unzip -d /opt/node2 /opt/neo-cli.zip
RUN unzip -d /opt/node3 /opt/neo-cli.zip
RUN unzip -d /opt/node4 /opt/neo-cli.zip

ADD ./configs/config1.json /opt/node1/neo-cli/config.json
ADD ./configs/protocol.json /opt/node1/neo-cli/protocol.json
ADD ./wallets/wallet1.db3 /opt/node1/neo-cli/

ADD ./configs/config2.json /opt/node2/neo-cli/config.json
ADD ./configs/protocol.json /opt/node2/neo-cli/protocol.json
ADD ./wallets/wallet2.db3 /opt/node2/neo-cli/

ADD ./configs/config3.json /opt/node3/neo-cli/config.json
ADD ./configs/protocol.json /opt/node3/neo-cli/protocol.json
ADD ./wallets/wallet3.db3 /opt/node3/neo-cli/

ADD ./configs/config4.json /opt/node4/neo-cli/config.json
ADD ./configs/protocol.json /opt/node4/neo-cli/protocol.json
ADD ./wallets/wallet4.db3 /opt/node4/neo-cli/

# Upload scripts
ADD ./scripts/run.sh /opt/
ADD ./scripts/start_consensus_node.sh /opt/

# neo-python setup
RUN git clone https://github.com/CityOfZion/neo-python.git /opt/neo-python
RUN cd /opt/neo-python && git checkout origin/master
RUN pip3 install -r /opt/neo-python/requirements.txt

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
