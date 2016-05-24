#!/bin/bash
# vim: ai ts=2 sts=2 et sw=2 fileencoding=utf-8 ft=sh
set -e

cd ./brimir
test -e ./tmp/pids/server.pid && rm ./tmp/pids/server.pid
docker-compose up -d
