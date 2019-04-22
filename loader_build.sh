#!/bin/sh

# 这是个更新 loader.zip 的快捷工具，请注意自己的路径

MY_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $MY_DIR
MY_DEST_DIR=$MY_DIR/res

source $QUICK_V3_ROOT/../jw_loader/build_luajit.sh $1

echo "mv $QUICK_V3_ROOT/../jw_loader/*.zip $MY_DEST_DIR/"
mv $QUICK_V3_ROOT/../jw_loader/*.zip $MY_DEST_DIR/
