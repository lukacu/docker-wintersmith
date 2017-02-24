#!/bin/sh

OUTFILE=$1

echo """server {
    listen 80 default_server backlog=2048;

    root /srv/www/build;
    index index.html;

    """ > $OUTFILE

if [ ! -z "$GITHUB_WEBHOOK" ]; then
echo """    location /$GITHUB_WEBHOOK {
		rewrite  ^ / break;
		proxy_pass http://127.0.0.1:9001;
	}""" >> $OUTFILE
fi

echo """    location / {
        try_files \$uri \$uri/ /index.html;
	}
}""" >> $OUTFILE

