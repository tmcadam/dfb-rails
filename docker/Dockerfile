FROM phusion/passenger-ruby26

ENV HOME /root

CMD ["/sbin/my_init"]

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update && apt install -y --no-install-recommends yarn

RUN mkdir /usr/src/app
RUN mkdir /usr/src/scripts

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
COPY webapp.conf /etc/nginx/sites-enabled/webapp.conf

WORKDIR /usr/src/app
EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
