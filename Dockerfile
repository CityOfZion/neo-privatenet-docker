FROM microsoft/dotnet:2.0-runtime

ARG VERSION
ARG NEO_CLI_VERSION=2.5.2
ENV DEBIAN_FRONTEND noninteractive
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

LABEL maintainer="City of Zion"
LABEL authors="hal0x2328, phetter, metachris, ashant, stevenjack"
LABEL version=$VERSION

# Install system dependencies. always should be done in one line
# https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run
RUN apt-get update && apt-get install -y \
    unzip \
    expect \
    libleveldb-dev \
    libssl-dev

# APT cleanup to reduce image size
RUN rm -rf /var/lib/apt/lists/*

# Download neo-cli
RUN curl -L -s -o /opt/neo-cli.zip https://github.com/neo-project/neo-cli/releases/download/v${NEO_CLI_VERSION}/neo-cli-ubuntu.16.04-x64.zip

# Add the neo-cli package
ADD ./neo-cli.zip /opt/neo-cli.zip
RUN unzip -d /opt/node /opt/neo-cli.zip

ADD wallets /wallets
ADD ./configs/config.json /opt/node/neo-cli/config.json
ADD ./configs/protocol.json /opt/node/neo-cli/protocol.json

# Upload scripts
ADD ./scripts/start_consensus_node.sh /opt/

# Inform Docker what ports to expose
EXPOSE 20333
EXPOSE 30333

# On docker run, start the consensus nodes
ENTRYPOINT ["/opt/start_consensus_node.sh"]
