#!/bin/bash
chown -R app:app /usr/src/app/public/system
./wait-for-it.sh "${DFB_DB_HOST}:${DFB_DB_PORT}" && bin/rake db:migrate
