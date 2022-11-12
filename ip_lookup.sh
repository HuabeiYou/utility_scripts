#!/bin/sh

curl ipinfo.ip/$1 | jq .
