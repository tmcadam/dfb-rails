# The Dictionary of Falklands Biographies ![Build Status](https://travis-ci.org/tmcadam/dfb-rails.svg?branch=master "Build Status")

### Versions
  - Ruby 2.6.6
  - Rails 6.1.3.1

## Dev/local environment
  - Install docker
  - Clone the project
  - Checkout staging branch
  - Install Ruby Gems 
    - `docker-compose -f docker/docker-compose.local.yml run --rm app bin/bundle install`
  - Create databases
    - `docker-compose -f docker/docker-compose.local.yml run --rm app bin/rails -e test db:create`
    - `docker-compose -f docker/docker-compose.local.yml run --rm app bin/rails -e development db:create`
  - Run migrations
    - `docker-compose -f docker/docker-compose.local.yml run --rm  app bin/rails -e test db:migrate`
    - `docker-compose -f docker/docker-compose.local.yml run --rm  app bin/rails -e development db:migrate`

### Environment Variables
  - create a `.env` file in the docker folder
    - DFB_DB_PASS => Password for the PostgreSQL user (set to anything, this variable creates and uses)
    - BACKUP_EMAIL => Email for backup script success
    - SMTP_USER => SMTP username
    - SMTP_PASS => SMTP password
    - DFB_COMMENTS_EMAIL_DEV => emails that comments and reports go to

### Run tests
  - `docker-compose -f docker/docker-compose.local.yml run --rm app rails test`

### Run development server
  - Populate development database with recent backup
  - Copy image foldes from the same backup into `public/system/`
  - Start the server
    - `docker-compose -f docker/docker-compose.local.yml run --rm --service-ports app bin/rails server -b 0.0.0.0`
  - Navigate to `http://localhost:3000` 

## Production Environment

### Configure Github Actions
Set the following secrets in Github Actions

  - DEPLOY_CONT_PROD - Caontainer name
  - DEPLOY_CONT_STAGING - Container name
  - DEPLOY_HOME - Home fold of the deployment host user
  - DEPLOY_HOST - Address of host deployment machine 
  - DEPLOY_KEY - SSH key
  - DEPLOY_PORT - SSH Port
  - DEPLOY_USER - User on the host machine
  - DEPLOY_PATH_PROD - Path to the volume
  - DEPLOY_PATH_STAGING - Path to the volume

### Build production docker image locally

  - `docker build -f docker/Dockerfile.prod -t rails:1.4 ./docker`
  - `docker save rails:1.4 -o docker/rails_1.4.tar`
  - Upload to portainer through UI for use

### Create conatainers

  - A Postgres instance will be required
  - Create containers using the latest base image(currently `rails:1.5`)
  - Set the following environment variables for container:
    - DFB_DB_PASS
    - DFB_DB_USER
    - DFB_DB_NAME
    - DFB_DB_HOST
    - DFB_DB_PORT
    - DFB_SECRET_KEY_BASE -> checkout rails docs for instructions how to generate
    - PASSENGER_APP_ENV -> production or staging
    - RAILS_ENV -> production or staging
      - Probably don't need both of these
    - SMTP_USER
    - SMTP_PASS
    - DFB_COMMENTS_EMAIL_PRODUCTION -> Can be multiple

## Admin Console Tasks

### Open a Rails console

Local
  ```shell
  docker-compose -f docker/docker-compose.local.yml exec app /bin/bash
  bin/rails console
  ```
Production
  ```shell
  sudo docker exec -it <CONTAINER_NAME> /bin/bash
  bin/rails console
  ```

### Creating a new user  
  - `User.create!(email: "guy@gmail.com", password: "111111", password_confirmation: "111111")`

### Adding a biography to an author
  
  - `BiographyAuthor.create!( biography_id: 496, author_id: 148, author_position: 1 )`

### Updating Rails
  - Update the version in Gemfile
  - in the local docker container run `bundle update rails`
  - commit and push the changes to Gemfile and Gemfile.lock
