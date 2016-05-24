#!/bin/bash
# vim: ai ts=2 sts=2 et sw=2 fileencoding=utf-8 ft=sh
set -e
sudo -v

VERS=0.7.0
curl -sL https://github.com/ivaldi/brimir/archive/$VERS.tar.gz | tar xz
mv brimir-$VERS ./brimir

cp ./conf/docker-compose.yml ./brimir/docker-compose.yml
cp ./conf/Dockerfile ./brimir/Dockerfile
cp ./conf/Gemfile ./brimir/Gemfile
cp ./conf/database.yml ./brimir/config/database.yml
cp ./conf/secrets.yml ./brimir/config/secrets.yml
cp ./conf/production.rb ./brimir/config/environments/production.rb

cd ./brimir
docker-compose build
docker-compose run web bin/rake assets:precompile RAILS_ENV=production
docker-compose run web bin/rake db:create db:schema:load RAILS_ENV=production
cd ..
sudo chown -R $LOGNAME: .
