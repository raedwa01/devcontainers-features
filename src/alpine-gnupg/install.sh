#!/bin/sh

set -e

echo "Activating feature 'alpine-gnupg'"

apk add --no-cache gnupg

echo 'Done!'
