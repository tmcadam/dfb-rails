# The Dictionary of Falklands Biographies ![Build Status](https://travis-ci.org/tmcadam/dfb-rails.svg?branch=master "Build Status")

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

    In the production/staging machines set the following variables. In webfaction set these in .bashrc.
    ```
    export BACKUP_EMAIL="<email address to send backups to>"
    export SMTP_USER="<email server smtp username>"
    export SMTP_PASSWORD="<email server smtp password>"

    export DFB_DB_PASS_PRODUCTION="<production db password>"
    export DFB_DB_USER_PRODUCTION="<production database user name>"
    export DFB_DB_PRODUCTION=<production db name>
    export DFB_SECRET_KEY_BASE_PRODUCTION="<rails generated secret key>"

    export DFB_DB_PASS_STAGING="<staging db password>"
    export DFB_DB_USER_STAGING="<staging db user name>"
    export DFB_DB_STAGING="<staging db name>"
    export DFB_SECRET_KEY_BASE_STAGING="<rails generated secret key>"
    ```
* Database creation

* Database initialization

   -  `sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'`
   - `wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -`
   - `sudo apt-get update`
   - `sudo apt-get install postgresql-9.4 pgadmin3 libpq-dev`
   - Open  `/etc/postgresql/[VERSION]/main/pg_hba.conf`
   - Change local access to `trust`
   - `sudo /etc/init.d/postgresql reload`
   - Add a role `sudo -u postgres createuser --interactive`

* How to run the test suite
  * ```rails test```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Creating a user
  * At the rails console
    * ```rails console```
    * ```User.create!(email: "guy@gmail.com", password: "111111", password_confirmation: "111111")```
