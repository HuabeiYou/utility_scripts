#!/bin/sh

curl ipinfo.io/$1 | jq .
