#!/bin/bash
## --------------------------------------------------
## Filename:        project-install.sh
## Revision:        latest stable
## Date:            2019/05/08
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     主要用于安装项目pip依赖包
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved

basepath=$(
    cd $(dirname $0)
    pwd
)
echo "---------------脚本位置["${basepath}"]---------------"

virtualenv_name=$1
if [ -z "$virtualenv_name" ]; then
    virtualenv_name="py365"
    echo "执行脚本时没有带参数，默认设置为["${name}"]"
fi

function install_pip_txt() {
    exist=$(pip3 --version)
    # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
    exec_status=$(echo $?)
    if [ $exec_status == "0" ]; then
        echo "切换pyenv虚拟环境为[${virtualenv_name}]，执行命令：pyenv activate ${virtualenv_name}"

        # pyenv activate $virtualenv_name
        source "$HOME/.pyenv/versions/$virtualenv_name/bin/activate"

        #  /Users/jason/.pyenv/versions/py365/bin/python -m pip list
        echo "查看pyenv虚拟环境python的安装路径：$(pyenv which python)"
        cd $basepath && $python_path pip install -r ./requirements.txt
        # 安装完成后，更新数据库
        pyenv rehash
    else
        echo "执行(pip3 --version)命令时，未检查到python3请先安装"
    fi
    return 0
}

echo "---------------函数开始执行---------------"
install_pip_txt
echo "---------------函数执行完毕---------------"
