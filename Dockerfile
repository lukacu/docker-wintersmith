FROM tozd/nginx-cron

RUN apt-get update \
 && apt-get -y install nodejs npm git \
 && apt-get autoremove -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/

RUN npm install wintersmith github-webhook-handler -g

RUN ln -s /usr/bin/nodejs /usr/bin/node

COPY ./etc /etc
COPY ./scripts /scripts

RUN mkdir /srv/www && chown www-data /srv/www


