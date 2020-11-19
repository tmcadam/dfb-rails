FROM phusion/passenger-ruby26

ENV HOME /root

CMD ["/sbin/my_init"]

RUN mkdir /usr/src/app
RUN mkdir /usr/src/scripts

RUN apt update -q && apt install -yq build-essential checkinstall wget && apt build-dep imagemagick -y
WORKDIR /usr/src
RUN wget http://www.imagemagick.org/download/ImageMagick-7.0.10-39.tar.gz
RUN tar -xzvf ImageMagick-7.0.10-39.tar.gz
WORKDIR /usr/src/ImageMagick-7.0.10-39
RUN ./configure && make && make install
RUN ldconfig /usr/local/lib
WORKDIR /usr/src
RUN rm -f ImageMagick-7.0.10-39.tar.gz && rm -rf ImageMagick-7.0.10-39

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt update -q && apt install -yq --no-install-recommends yarn

RUN apt update
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt install -y nodejs
RUN apt install -y default-jre

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
COPY webapp.conf /etc/nginx/sites-enabled/webapp.conf

WORKDIR /usr/src/app
EXPOSE 80

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
