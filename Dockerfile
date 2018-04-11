#
# Etherpad lite Dockerfile
#
# Based on instructions from https://github.com/ether/etherpad-lite
#

FROM node:9

MAINTAINER Johannes Bornhold <johannes@bornhold.name>


# Prepare etherpad
RUN mkdir /src
WORKDIR /src

# Dependencies based on docs
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install \
    gzip git-core curl python libssl-dev pkg-config build-essential zip unzip

ARG EP_VERSION=1.6.5
RUN wget https://github.com/ether/etherpad-lite/archive/release/$EP_VERSION.zip -O release.zip &&\
    unzip release.zip &&\
    rm -f release.zip &&\
    mv etherpad-lite-release-$EP_VERSION etherpad &&\
    sed '/installDeps.sh/d' etherpad/bin/run.sh -i

WORKDIR /src/etherpad

# Install dependencies
RUN bin/installDeps.sh
RUN npm install sqlite3

# Add the settings
ADD config/ /src/etherpad/

# Install plugins
RUN npm install \
    ep_headings2 \
    ep_author_neat \
    ep_tasklist \
    Informatic/ep_markdownify#patch-1 \
    ep_monospace_default


RUN useradd etherpad
USER etherpad

EXPOSE 9001
VOLUME ["/data"]

CMD ["bin/configure_and_run.sh"]
