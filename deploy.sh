#!/bin/bash
APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Deploy: Changing file permissions"
cd $APP_DIR
chmod +x -R $APP_DIR
chown -R app:app $APP_DIR

echo "Deploy: Installing dependencies"
bundle install
echo "Deploy: Applying migrations"
rake db:migrate
echo "Deploy: Compiling assets"
bundle exec rake assets:precompile
