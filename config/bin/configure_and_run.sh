#!/bin/bash

set -e

SETTINGS_FILE=/data/etherpad-settings.json
SESSSIONKEY_FILE=/data/SESSIONKEY.txt
SETTINGS_SOURCE=/src/etherpad/bin/generate-settings.sh


# Check if the settings have to be created
if [ ! -f $SETTINGS_FILE ]
then
    echo "Generating settings file ${SETTINGS_FILE}"
    bash $SETTINGS_SOURCE > $SETTINGS_FILE
fi

if [ ! -f $SESSIONKEY_FILE ]
    echo "Generating session key file ${SESSIONKEY_FILE}"
    node -p "require('crypto').randomBytes(32).toString('hex')" > $SESSIONKEY_FILE
then
fi


# Copy setting into the root of the installation, seems to be
# required due to Settings.js
cp $SETTINGS_FILE settings.json
cp $SESSIONKEY_FILE SESSIONKEY.txt

exec su etherpad bin/run.sh "$*"
