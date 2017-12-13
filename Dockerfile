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
RUN unzip -d /opt/node /opt/neo-cli.zip

ADD ./configs/config.json /opt/node/neo-cli/config.json
ADD ./configs/protocol.json /opt/node/neo-cli/protocol.json

# Upload scripts
ADD ./scripts/start_consensus_node.sh /opt/

# Inform Docker what ports to expose
EXPOSE 20333
EXPOSE 30333

# On docker run, start the consensus nodes
ENTRYPOINT ["/opt/start_consensus_node.sh"]
