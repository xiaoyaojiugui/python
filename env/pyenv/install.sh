#!/bin/bash
## --------------------------------------------------
## Filename:        install.sh
## Revision:        latest stable
## Date:            2019/05/08
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     主要用于管理多版本python（默认python-3.6.5）、配置python环境变量
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved

basepath=$(
    cd $(dirname $0)
    pwd
)
echo "---------------脚本位置["${basepath}"]---------------"

function check_pyenv_install() {
    # $@表示函数的所有参数
    for app_name in $@; do
        echo "检查[${app_name}]应用是否安装"
        exist=$(brew list $app_name)
        # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
        exec_status=$(echo $?)
        if [ $exec_status == "0" ]; then
            echo "["${app_name}"]应用已安装，查看版本号：pyenv --version"
            pyenv --version
        else
            echo "["${app_name}"]应用未安装，执行命令：brew install ${app_name}"
            brew install $app_name
            # 对数据进行更新
            pyenv rehash
        fi
    done
    return 0
}

function check_python_install() {
    # $@表示函数的所有参数
    for python_version in $@; do
        echo "检查[python $python_version]是否安装"
        exist=$(pyenv global $python_version)
        # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
        exec_status=$(echo $?)
        if [ $exec_status == "0" ]; then
            echo "[python]已安装，查看版本号：pyenv versions"
            pyenv versions | awk NR!=1{print}
        else
            echo "[python]已安装，执行命令：pyenv install ${python_version}"
            pyenv install $python_version
            echo "配置[python]环境变量，执行命令：pyenv global ${python_version}"
            pyenv global $python_version
        fi
    done
    return 0
}

# 将配置文件写入.bash_profile
function write_bash_profile() {
    #获取python安装路径
    soft_link="/usr/local/bin/python3"
    relative_path=$(pyenv which python3)
    if [ -f $soft_link ]; then
        echo "软链接已存在[${soft_link}]，无需重复创建"
    else
        echo "创建软链接，执行命令：ln -s $relative_path $soft_link"
        ln -s $relative_path $soft_link
    fi

    # 获取配置文件路径
    bash_profile=$HOME"/"$(basename ~/.bash_profile)
    # 判断需要添加的配置是否存在
    alias_name=$(grep -w 'export PYTHON_HOME' $bash_profile)
    if [ ! -z "$alias_name" ]; then
        echo "配置信息已存在["${alias_name}"]"
    else
        echo "查看python安装路径，$(dirname $relative_path)"
        dirname_path=$(dirname $relative_path)

        echo "配置信息不存在，将文件写入["${bash_profile}"]"
        # 获取根据关键字查询的行数，开始行数
        start_num=$(grep -n 'alias zip' $bash_profile | tail -n 1 | cut -d ":" -f1)
        # 文本总行数
        total_num=$(cat $bash_profile | wc -l)
        # 文本前缀部分
        text_prefix=$(sed -n "1,$(($start_num - 1))p" $bash_profile)
        # 文本后缀部分
        text_suffix=$(sed -n "${start_num},${total_num}p" $bash_profile)
        # 将追加的文本覆盖原有文件
        cat >$bash_profile <<EOF
${text_prefix}

# 配置python3安装目录，执行命令：pyenv which python3
export PYTHON_HOME=${dirname_path%/*}
alias python2=/usr/bin/python
alias python3=$soft_link
alias python=python3

${text_suffix}:\$PYTHON_HOME/bin

# 配置eval变量
EOF
        echo 'if which pyenv >/dev/null; then eval "$(pyenv init -)"; fi' >>$bash_profile
        echo 'if which pyenv-virtualenv-init >/dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >>$bash_profile
        source $bash_profile
    fi
    return 0
}

echo "---------------函数开始执行---------------"
check_pyenv_install pyenv pyenv-virtualenv
check_python_install 3.6.5
write_bash_profile
echo "---------------函数执行完毕---------------"
