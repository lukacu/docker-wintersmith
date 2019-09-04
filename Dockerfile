FROM lukacu/webhook

RUN apk add --no-cache git

RUN npm install wintersmith -g

COPY ./scripts /scripts

