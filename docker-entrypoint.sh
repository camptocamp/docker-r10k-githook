#!/bin/bash
set -e

DIR=/docker-entrypoint.d

if [[ -d "$DIR" ]]
then
  /bin/run-parts "$DIR"
fi

exec "$@"
