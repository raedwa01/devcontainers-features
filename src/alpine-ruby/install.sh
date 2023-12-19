#!/bin/sh

set -e

echo "Activating feature 'alpine-ruby'"

echo "Step 1, Add to the apk repository list"
if [! grep -q edge/community /etc/apk/repositories]; then
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
fi
if [! grep -q edge/testing /etc/apk/repositories]; then
    echo "https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
fi

echo "Step 2, Install Ruby"
apk add --no-cache ruby

echo 'Done!'
