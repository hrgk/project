#!/bin/sh

# 复制项目脚本，用来测试多个客户端的情况所用的脚本

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

DEST_DIR="$HOME/$1"

if [ -d "$DEST_DIR" ]; then
    if [ "$2" = "del" ]; then
        rm -rf $DEST_DIR/*
        rm -rf $DEST_DIR/.data
    fi
fi

if [ -d "$DEST_DIR" ]; then
    echo "NOTICE: $DEST_DIR IS EXIST, FILES WILL BE OVERWRITE!"
    # exit 1
fi

mkdir -p $DEST_DIR

rsync -rqu $DIR/res/ $DEST_DIR/res
rsync -rqu $DIR/src/ $DEST_DIR/src
rsync -rqu $DIR/*.sh $DEST_DIR/
