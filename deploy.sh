#!/bin/bash

APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WEBAPP_DIR="$(dirname "$APP_DIR")"

export PATH=$WEBAPP_DIR/bin:$PATH
export GEM_HOME=$WEBAPP_DIR/gems
export RUBYLIB=$WEBAPP_DIR/lib

cd $APP_DIR/app
bundle install
restart
