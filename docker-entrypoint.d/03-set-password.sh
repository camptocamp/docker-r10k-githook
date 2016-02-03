#!/bin/bash
set -e

if test -n "${PASSWORD}"; then
  echo "r10k:${PASSWORD}" | chpasswd
fi
