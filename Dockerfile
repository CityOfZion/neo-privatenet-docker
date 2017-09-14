# NEO private network - Dockerfile

FROM ubuntu:16.04
MAINTAINER hal0x2328

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y mininet netcat curl wget unzip less python screen
RUN apt-get install -y ca-certificates apt-transport-https
RUN apt-get install -y libleveldb-dev sqlite3 libsqlite3-dev

RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-xenial-prod xenial main" > /etc/apt/sources.list.d/dotnetdev.list

RUN apt-get update && apt-get install -y dotnet-sdk-2.0.0

RUN wget -O /opt/neo-cli.zip https://github.com/neo-project/neo-cli/releases/download/v2.3.2/neo-cli-ubuntu.16.04-x64.zip

RUN unzip -d /opt/node1 /opt/neo-cli.zip
RUN unzip -d /opt/node2 /opt/neo-cli.zip
RUN unzip -d /opt/node3 /opt/neo-cli.zip
RUN unzip -d /opt/node4 /opt/neo-cli.zip

ADD ./configs/config1.json /opt/node1/neo-cli/config.json
ADD ./configs/protocol.json /opt/node1/neo-cli/protocol.json
ADD ./configs/config2.json /opt/node2/neo-cli/config.json
ADD ./configs/protocol.json /opt/node2/neo-cli/protocol.json
ADD ./configs/config3.json /opt/node3/neo-cli/config.json
ADD ./configs/protocol.json /opt/node3/neo-cli/protocol.json
ADD ./configs/config4.json /opt/node4/neo-cli/config.json
ADD ./configs/protocol.json /opt/node4/neo-cli/protocol.json
ADD ./scripts/neo-mininet.py /opt/neo-mininet.py
