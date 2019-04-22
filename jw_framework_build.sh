#!/bin/sh

# 这是个更新 dj_framework.zip 的快捷工具，请注意自己的路径

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MY_DEST_DIR=$MY_DIR/res

source $QUICK_V3_ROOT/../jw_framework/build_luajit.sh $1

echo "mv $QUICK_V3_ROOT/../jw_framework/*.zip $MY_DEST_DIR/"
mv $QUICK_V3_ROOT/../jw_framework/*.zip $MY_DEST_DIR/
