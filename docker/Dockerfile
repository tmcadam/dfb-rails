FROM phusion/passenger-ruby26

ENV HOME=/root \
    RAILS_ENV=production \
    SECRET_KEY_BASE=dummy_secret_key_base_for_docker_build

CMD ["/sbin/my_init"]

# Install system dependencies in a single layer, clean up immediately
# Fix GPG key for Phusion Passenger repo, then install packages
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D870AB033FB45BD1 && \
    apt-get update -q && \
    apt-get install -yq --no-install-recommends \
      imagemagick \
      default-jre \
      nodejs \
      npm && \
    npm install --global yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install bundler -v 1.17.3

# Configure nginx
RUN rm -f /etc/service/nginx/down && \
    rm /etc/nginx/sites-enabled/default
COPY docker/webapp.conf /etc/nginx/sites-enabled/webapp.conf

WORKDIR /usr/src/app

# Copy dependency files first (better layer caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY package.json yarn.lock ./
RUN yarn install --production

# Copy application code
COPY app/ ./app/
COPY bin/ ./bin/
COPY config/ ./config/
COPY db/ ./db/
COPY lib/ ./lib/
COPY public/ ./public/
COPY vendor/ ./vendor/
COPY Rakefile config.ru ./

# Precompile assets
RUN bin/rake assets:precompile

# Copy and set up entrypoint
COPY docker/wait-for-it.sh ./
RUN chmod +x ./wait-for-it.sh

EXPOSE 80

# Use an init script instead of overriding CMD
COPY docker/rails-init.sh /etc/my_init.d/99-rails-init.sh
RUN chmod +x /etc/my_init.d/99-rails-init.sh
