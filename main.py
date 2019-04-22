# coding:utf-8

from ufile import filemanager
from ufile import config
import os

config.set_default(uploadsuffix='.cn-gd.ufileos.com')
config.set_default(connection_timeout=60)

public_key = 'TOKEN_84e97dbe-7092-47aa-8d1a-f131ebcbb944'
private_key = '02878b78-9957-4943-ac8e-54c661612a87'
public_bucket = 'letugame'

upload_handler = filemanager.FileManager(public_key, private_key)
project_name = "letugame"
source_res_dir = "update_build"


class SearchFile:
    def __init__(self):
        self.fileList = []

        self.recursiveDir(source_res_dir)

    def recursiveDir(self, srcPath):
        ''' 递归指定目录下的所有文件'''
        dirList = []  # 所有文件夹
        # print srcPath
        files = os.listdir(srcPath)  # 返回指定目录下的所有文件，及目录（不含子目录）
        # print files
        for f in files:
            # 目录的处理
            if (os.path.isdir(srcPath + '/' + f)):
                if (f[0] == '.'):
                    # 排除隐藏文件夹和忽略的目录
                    pass
                else:
                    # 添加需要的文件夹
                    dirList.append(f)
            # 文件的处理
            elif (os.path.isfile(srcPath + '/' + f)):
                if f[0] != '.':
                    self.fileList.append(srcPath + '/' + f)  # 添加文件

        # 遍历所有子目录,并递归
        for dire in dirList:
            # 递归目录下的文件
            self.recursiveDir(srcPath + '/' + dire)

    def getAllFile(self):
        ''' get all file path'''
        return tuple(self.fileList)


def DoTest():
    searchfile = SearchFile()
    fileList = list(searchfile.getAllFile())
    for path in fileList:
        get_path = project_name + '/'
        split_path = path.split("/")
        for val in split_path[1:]:
            if os.path.isdir(val):
                get_path += val + '/'
            else:
                get_path += val
        print(get_path[:-1])


def GenRightFilePath(path):
    get_path = project_name + '/'
    split_path = path.split("/")
    for val in split_path[1:]:
        get_path += val + '/'

    #print(get_path[:-1])
    return get_path[:-1]

def DoUpload():
    searchfile = SearchFile()
    fileList = list(searchfile.getAllFile())
    #print(fileList)

    for val in fileList:
        localfile = val
        uploadhit_key = GenRightFilePath(val)
        ret, resp = upload_handler.uploadhit(public_bucket, uploadhit_key,localfile)

        if resp.status_code == 404:
            ret, resp = upload_handler.putfile(public_bucket, uploadhit_key, localfile)

            if resp.status_code != 200:
                print(localfile + "_" + uploadhit_key + "_" + str(resp.status_code), 'error.txt')
                break

def main():
    DoUpload()

if __name__ == '__main__':
    main()
