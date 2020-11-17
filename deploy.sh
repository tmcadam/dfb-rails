#!/bin/bash
APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $APP_DIR
chmod +x -R $APP_DIR
chown -R app:app $APP_DIR
#chmod -R 0666 $APP_DIR/log

bundle install
rake db:migrate
bundle exec rake assets:precompile
