#!/bin/sh

ENV=$(dirname $0)/.env
URI=$(grep '^MONGODB_PROD_URI=' $ENV | sed 's/^MONGODB_PROD_URI=//')
USER=$(grep '^MONGODB_USER=' $ENV | sed 's/^MONGODB_USER=//')
PASSWORD=$(grep '^MONGODB_PASSWORD=' $ENV | sed 's/^MONGODB_PASSWORD=//')

mongosh $URI \
	--username $MONGODB_USER \
	--authenticationDatabase admin \
	--password $MONGODB_PASSWORD
