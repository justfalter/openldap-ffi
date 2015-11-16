FROM ubuntu:trusty
MAINTAINER Mike Ryan <falter@gmail.com>

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y eatmydata && \
  eatmydata apt-get -y upgrade && \
  eatmydata apt-get install -y wget ca-certificates software-properties-common ldap-utils libldap-2.4-2 && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN apt-add-repository ppa:brightbox/ruby-ng

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  eatmydata apt-get install -y build-essential && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  eatmydata apt-get install -y ruby2.2 ruby2.2-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

RUN gem install bundler

ADD spec/docker/dev/entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

RUN mkdir /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
WORKDIR /app
RUN bundle install

ADD spec/docker/ldapserver/ldapserver.test.crt /usr/local/share/ca-certificates/ldapserver.test.crt
RUN update-ca-certificates

ENTRYPOINT [ "/entrypoint.sh" ]
