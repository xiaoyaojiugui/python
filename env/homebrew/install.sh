#!/bin/bash
## --------------------------------------------------
## Filename:        install.sh
## Revision:        latest stable
## Date:            2019/05/09
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     主要安装管理工具homebrew、代理国内镜像（默认配置清华大学开源软件镜像站）
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved
basepath=$(
    cd $(dirname $0)
    pwd
)
echo "---------------脚本位置["${basepath}"]---------------"

name=$1
if [ -z "$name" ]; then
    name="qinghua"
    echo "执行脚本时没有带参数，默认设置为["${name}"]"
fi

function check_homebrew_install() {
    echo "检查[homebrew]是否安装"
    exist=$(brew -v)
    # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
    exec_status=$(echo $?)
    if [ $exec_status == "0" ]; then
        echo "[homebrew]应用已安装，查看版本号：brew -v"
        # 打印文本第一行：awk 'NR==1{print}'
        brew -v
    else
        echo "[homebrew]应用未安装，执行安装命令"
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi
    return 0
}

function tsinghua_mirrors() {
    if [[ $name == "qinghua" ]]; then
        echo "更换镜像["${name}"]，执行命令：cd $(brew --repo)"
        cd "$(brew --repo)"
        git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
        git remote -v

        echo "更换镜像["${name}"]，执行命令：cd $(brew --repo)/Library/Taps/homebrew/homebrew-core"
        cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
        git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
        git remote -v
    fi
    return 0
}

function homebrew_mirrors() {
    if [ $name == "homebrew" ]; then
        echo "更换镜像["${name}"]，执行命令：cd $(brew --repo)"
        cd "$(brew --repo)"
        git remote set-url origin https://github.com/Homebrew/brew.git
        git remote -v

        echo "更换镜像["${name}"]，执行命令：cd $(brew --repo)/Library/Taps/homebrew/homebrew-core"
        cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
        git remote set-url origin https://github.com/Homebrew/homebrew-core
        git remote -v
    fi
    return 0
}

echo "---------------函数开始执行---------------"
check_homebrew_install
tsinghua_mirrors
homebrew_mirrors
echo "---------------函数执行完毕---------------"

echo "更新镜像["${name}"]由于更新太慢未打开，可手动在终端执行：brew update"
#brew update
