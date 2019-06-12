# The Dictionary of Falklands Biographies ![Build Status](https://travis-ci.org/tmcadam/dfb-rails.svg?branch=master "Build Status")

### Versions
  - Ruby 2.5.5
  - Rails 5.2.3

### Dev/local environment configuration
  - Clone the project
  - Install RVM system wide
    - Follow instructions on Github https://github.com/rvm/ubuntu_rvm
    - Add user to the rvm group `sudo usermod -a -G rvm [USERNAME]`
    - Reboot after install
    - Add a .ruby-version and .ruby-gemset file to project folder
      - Install the current Ruby version `rvm install "ruby-2.5.5"`
      - Generate the version file `rvm --ruby-version use 2.5.5`
      - Generate the gemset file `rvm --ruby-version use 2.5.5@dfb-rails`
  - `gem install bundler`
  - `bundle install`
  - `rails server`
  - NB. To send real emails in dev set `SMTP_USER`, `SMTP_PASSWORD` and `DFB_COMMENTS_EMAIL_DEV` environment variables, and comment out the email test settings in config/environments/development.rb.

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
```shell
    export BACKUP_EMAIL="<email address to send backups to>"
    export SMTP_USER="<email server smtp username>"
    export SMTP_PASSWORD="<email server smtp password>"
    export DFB_COMMENTS_EMAIL_PRODUCTION="email to send comment approval emails"
    export DFB_COMMENTS_EMAIL_STAGING="email to send comment approval emails for testing"

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
  ```shell
    export PATH=$PWD/bin:$PATH
    export GEM_HOME=$PWD/gems
    export RUBYLIB=$PWD/lib
  ```

### Creating a user
  - Use these commands from `~/webapps/<application-name>/app`.
  ```shell
     rails console production
     User.create!(email: "guy@gmail.com", password: "111111", password_confirmation: "111111")
  ```

### Adding a biography to an author
  - Use these commands from `~/webapps/<application-name>/app`.
  ```shell
     rails console production
     BiographyAuthor.create!( biography_id: 496, author_id: 148, author_position: 1 )
  ```

### Configuring SSL
  - built in tools in Webfaction UI

### Updating Ruby version in Webfaction
  - Navigate to the webapp bin directory
  - Replace links to the required Ruby version
  - export the environment variables (as above)
  - in the webapp root directory `gem install bundler`
  - in the webapp app directory `bundle install`
  - `restart`

### Updating Rails
  - Update the version in Gemfile
  - export the environment variables (as above)
  - in the webapp app directory `bundle update rails`
  - commit and push the changes to Gemfile and Gemfile.lock
