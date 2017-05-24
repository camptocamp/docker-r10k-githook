#!/bin/sh

/go/bin/github_pki -a /opt/puppetlabs/r10k/.ssh/authorized_keys
chown r10k. /opt/puppetlabs/r10k/.ssh/authorized_keys
