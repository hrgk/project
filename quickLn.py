#!/usr/bin/env python3

import os
import os.path
import sys
import argparse

parser = argparse.ArgumentParser(description="快速生成软链接")
parser.add_argument("-i", "--input", help="input dir path. default: .", default=".")
parser.add_argument("-c", "--count", help="create count for link. default: 3", default=3)
parser.add_argument("-o", "--output", help="output path. default: .. ", default="..")

args = parser.parse_args()

print(args)

root_dir = os.path.abspath(args.input)

parent_path, dir_name = os.path.split(root_dir)

ignore_list = ["debug.log", "http.log", "socket.log"]

for i in range(args.count):
    target_path = root_dir + "_" + str(i + 1)
    if os.path.exists(target_path):
        print("ignore target path:" + target_path)
        continue

    print("create target path:" + target_path)
    os.mkdir(target_path)

    for file_name in os.listdir(root_dir):
        path_name = os.path.join(root_dir, file_name)
        if file_name[0] == "." or file_name in ignore_list:
            continue

        os.system("ln -s " + path_name + " " + os.path.join(target_path, file_name))

    print("finished target path:" + target_path + "\n")
