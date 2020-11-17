#!/bin/bash

APP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd $APP_DIR
bundle install
rake db:migrate
bundle exec rake assets:precompile

if [ $1 == "production" ]; then
    bash "$APP_DIR/install_cronjobs.sh"
fi

TEMP_FILE='/etc/nginx/sites-enabled/webapp.conf'

cat > "$TEMP_FILE" <<-EOSQL
server {
  listen 80;
  #server_name dfb;
  root /usr/src/app/public;

  passenger_enabled on;
  passenger_user root;

  passenger_ruby /usr/bin/ruby2.6;

EOSQL

echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_app_env $RAILS_ENV ;" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_DB_STAGING $DFB_DB_STAGING" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_DB_PASS_STAGING $DFB_DB_PASS_STAGING" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_DB_USER_STAGING $DFB_DB_USER_STAGING" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_DB_STAGING_HOST $DFB_DB_STAGING_HOST" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_DB_STAGING_PORT $DFB_DB_STAGING_PORT" >> "$TEMP_FILE"
echo -ne "\t" >> "$TEMP_FILE" && echo "passenger_env_var DFB_SECRET_KEY_BASE_STAGING $DFB_SECRET_KEY_BASE_STAGING" >> "$TEMP_FILE"

echo '}' >> "$TEMP_FILE"

restart
