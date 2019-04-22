#!/bin/sh

find res -name '*.png' -exec pngquant --force --ext .png {} ';'
