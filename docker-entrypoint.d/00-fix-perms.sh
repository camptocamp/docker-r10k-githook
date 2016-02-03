#!/bin/bash
set -e

chown r10k:r10k -R /opt/puppetlabs/r10k/cache \
  /etc/puppetlabs/code/environments \
  /srv/puppetmaster.git
