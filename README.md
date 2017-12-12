# The Dictionary of Falklands Biographies ![Build Status](https://travis-ci.org/tmcadam/dfb-rails.svg?branch=master "Build Status")

### Versions
  - Ruby 2.2.7
  - Rails 5.1.4

### Dev/local environment configuration
  - Clone the project
  - Install RVM system wide
    - If you add .ruby-gemset and .ruby-version files, it will automatically use RVM in the project folder
    - Alternatively you can run `rvm use 2.2.7@dfb-rails` each time you enter the folder
    - It will prompt to install the correct ruby version through RVM if not available on the sytem - run the suggested command
  - `gem install bundler`
  - `bundle install`
  - `rails server`

### Dev/local database Configuration
  - Install Postgres 9.4
    -  `sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'`
    - `wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -`
    - `sudo apt-get update`
    - `sudo apt-get install postgresql-9.4 pgadmin3 libpq-dev`
  -  Configure permissive local access
    - Open  `/etc/postgresql/[VERSION]/main/pg_hba.conf`
    - Change local access to `trust`
    - `sudo /etc/init.d/postgresql reload`
    - Add a role `sudo -u postgres createuser --interactive`
      - role name -> system user name
      - superuser -> y
  - Create databases
    - `createdb dfb_development`
    - `createdb dfb_test`

### Running tests
`rails test`

### Deployment instructions

#### Travis
Set the following variables in Travis UI (allows deployment into Webfaction)

 - DEPLOY_BRANCH -> origin/master
 - DEPLOY_BRANCH_STAGING -> origin/staging
 - DEPLOY_REPO -> tmcadam/dfb-rails
 - DEPLOY_HOST -> webfaction host name
 - DEPLOY_USER -> webfaction user name
 - DEPLOY_HOME -> path to webfaction home folder
 - DEPLOY_PASS -> webfaction password
 - DEPLOY_PATH -> /home/username/webapps/dfb-staging/app
 - DEPLOY_PATH_STAGING -> /home/username/webapps/dfb-staging/app

#### Webfaction Configuration

- Setup two Rails apps in the Webfaction UI e.g.
  - dfb
  - dfb-staging
- Copy the git_deploy script
  - Copy the git_deploy.sh script from https://github.com/tmcadam/webfaction-tools, to home folder in Webfaction shell
- Add the following variables. In Webfaction shell set these in `.bashrc`. Used by rails and the backup scripts.
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

### Using rails commands in Webfaction
  - Use these commands from `~/webapps/<application-name>/` folder to run Rails related commands in Webfaction shell.
   ```
    export PATH=$PWD/bin:$PATH
    export GEM_HOME=$PWD/gems
    export RUBYLIB=$PWD/lib
    ```

### Creating a user
  - ```rails console```
  - ```User.create!(email: "guy@gmail.com", password: "111111", password_confirmation: "111111")```

### Configuring SSL
  - see https://github.com/tmcadam/webfaction-tools
