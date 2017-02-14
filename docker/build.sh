#!/bin/bash

USER_ID=${LOCAL_USER_ID:-99999}
echo "Adding dashboard user with uid/gid $USER_ID..."
addgroup dashboard -g "$USER_ID"
adduser -s /bin/bash -D -G dashboard -u "$USER_ID" dashboard

echo "Changing ownership to dashboard user for $WORKDIR..."
chown -R dashboard:dashboard "$WORKDIR"

echo "Initializing and updating submodules for user modules..."
gosu dashboard git submodule update --init


echo "Copying example db.json for the globalnavbar..."
if [ ! -f app/user-modules/openmrs-contrib-id-globalnavbar/data/db.json ]; then
    gosu dashboard cp -v app/user-modules/openmrs-contrib-id-globalnavbar/data/db.example.json app/user-modules/openmrs-contrib-id-globalnavbar/data/db.json
fi

echo "Setting file permissions for globalnavbar data directory..."
chown -R dashboard:dashboard app/user-modules/openmrs-contrib-id-globalnavbar/data/

echo "Copying example SSO module configuration..."
gosu dashboard cp -a app/user-modules/openmrs-contrib-id-sso/conf.example.js app/user-modules/openmrs-contrib-id-sso/conf.js

echo "Installing all dependencies for all user-modules"
gosu dashboard git submodule foreach npm install

echo "Installing dashboard dependencies..."
gosu dashboard bash -c "npm install"

echo "Done building."