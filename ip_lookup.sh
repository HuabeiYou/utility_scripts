#!/bin/sh

IP=$1
ENV=$(dirname $0)/.env
TOKEN=$(grep '^TOKEN_IPINFO=' $ENV | sed 's/^TOKEN_IPINFO=//')

if [[ -z "$TOKEN" ]]; then
	curl ipinfo.io/$IP | jq .
else
	curl ipinfo.io/$IP?token=$TOKEN | jq .
fi
