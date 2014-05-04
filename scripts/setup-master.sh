#!/bin/sh

PUPPET_DIR=/etc/puppet

# Install puppet master package
if [ -f /etc/redhat-release ]; then
    yum -y install puppetmaster
else
    apt-get update -y
    apt-get install -y puppetmaster
    apt-get install -y ruby-bundler
    apt-get install -y git
fi

if [ ! -d "$PUPPET_DIR" ]; then
    mkdir -p $PUPPET_DIR
fi

cp /vagrant/puppet/Puppetfile $PUPPET_DIR

if [ "$(gem list -i '^librarian-puppet$')" = "false" ]; then
    # install librarian-puppet
    gem install librarian-puppet
    cd $PUPPET_DIR && librarian-puppet install --clean
else
    cd $PUPPET_DIR && librarian-puppet update
fi

cd $PUPPET_DIR && librarian-puppet show --verbose
