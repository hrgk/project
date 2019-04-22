#!/usr/bin/env bash

# set .bash_profile or .profile
if [ -f ~/.bash_profile ]; then
PROFILE_NAME=~/.bash_profile
else
PROFILE_NAME=~/.profile
fi
source $PROFILE_NAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_ROOT="$DIR/../../.."
APP_ANDROID_ROOT="$DIR"
export COCOS2DX_ROOT=`cat ~/.QUICK_V3_ROOT`

if [ -d "$APP_ANDROID_ROOT"/assets ]; then
    rm -rf "$APP_ANDROID_ROOT"/assets/*
fi
mkdir -p "$APP_ANDROID_ROOT"/assets
chmod 755 "$APP_ANDROID_ROOT"/assets
mkdir -p "$APP_ANDROID_ROOT"/assets/src


echo "- cleanup"
if [ -d "$APP_ANDROID_ROOT"/bin ]; then
    rm -rf "$APP_ANDROID_ROOT"/bin/*.apk
fi

source "$APP_ROOT"/game_build.sh $1

echo "- copy config"
cp -rf "$APP_ROOT"/build/res "$APP_ANDROID_ROOT"/assets/

cp -f "$APP_ANDROID_ROOT"/SDK/*.so "$APP_ANDROID_ROOT"/libs/armeabi/
