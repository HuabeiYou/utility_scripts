#!/bin/sh

IP=$1
TOKEN=$(sed "s/TOKEN_IPINFO=//g" $(dirname $0)/.env)

if [[ -z "$TOKEN" ]]; then
	curl ipinfo.io/$IP | jq .
else
	curl ipinfo.io/$IP?token=$TOKEN | jq .
fi
