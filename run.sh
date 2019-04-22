#!/bin/sh

# player 支持下列命令行参数：

# -workdir 设置项目目录，等同于 player Open Project 对话框中的 Project Directory
# -file 设置启动脚本，等同于 Open Project 对话框中 Script File
# -writable 设置 device.writablePath 对应的路径，未指定时为项目目录
# -package.path 设置附加的 Lua 模块加载路径，格式为 “/mylualib1;/mylualib2;;”，用 “;” 分割多个路径，最后一个 “;” 表示 -workdir 所指目录
# -size 设置模拟器的屏幕尺寸，格式为“宽度x高度”
# -scale 设置模拟器的缩放比例，格式为 “1.0”，“0.5” 等数值
# -write-debug-log 将调试信息写入 debug.log 文件，该文件存放于项目目录中
# -disable-write-debug-log 禁止写入调试信息到 debug.log 文件
# -console 显示调试信息控制台窗口
# -disable-console 禁止调试信息控制台窗口
# -load-framework 载入 QUICK_COCOS2DX_ROOT 环境变量所指 quick-cocos2d-x 目录中的预编译框架文件
# -disable-load-framework 禁止载入预编译框架文件
# -offset 启动时模拟器窗口的偏移位置，格式为 “{X偏移量,Y偏移量}”
# -portrait 指定以竖屏启动

# 项目根目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
bin=$QUICK_V3_ROOT/player3.app/Contents/MacOS/player3
file=src/main.lua
size=1840x800
# size=1280x720
# size=1280x800
scale=0.5

$bin -workdir $DIR -file $file -size $size -scale $scale
