#!/bin/bash
## --------------------------------------------------
## Filename:        install.sh
## Revision:        latest stable
## Date:            2019/09/04
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     主要用于管理虚拟环境
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved

basepath=$(
    cd $(dirname $0)
    pwd
)
echo "---------------脚本位置["${basepath}",$1]---------------"

function check_pyenv_virtualenv() {
    # $@表示函数的所有参数
    for env_name in $@; do
        echo "检查虚拟环境[${env_name}]是否存在"
        exist=$(pyenv virtualenv $env_name)
        # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
        exec_status=$(echo $?)
        if [ $exec_status == "0" ]; then
            echo "虚拟环境["${env_name}"]不存在，查看版本号：pyenv virtualenv ${env_name}"
            pyenv virtualenv $env_name
        else
            echo "虚拟环境["${env_name}"]已存在，执行命令：pyenv global ${env_name}"
            pyenv global $env_name
        fi
    done
    return 0
}

# 将配置文件写入.bash_profile
function write_bash_profile() {
    #获取pip安装路径
    soft_link="/usr/local/bin/pip3"
    relative_path=$(pyenv which pip3)
    if [ -f $soft_link ]; then
        echo "软链接已存在[${soft_link}]，无需重复创建"
    else
        echo "创建软链接，执行命令：ln -s $relative_path $soft_link"
        ln -s $relative_path $soft_link
    fi

    # 获取配置文件路径
    bash_profile=$HOME"/"$(basename ~/.bash_profile)
    echo "查看pip安装路径，$(dirname $relative_path)"
    dirname_path=$(dirname $relative_path)
    # 判断需要添加的配置是否存在
    alias_name=$(grep -w 'export PIP_HOME' $bash_profile)
    if [ ! -z "$alias_name" ]; then
        echo "配置已存在["${alias_name}"]替换为[export PIP_HOME=${dirname_path%/*}]"
        # 获取关键字的开始行数
        start_num=$(grep -n 'export PIP_HOME' $bash_profile | tail -n 1 | cut -d ":" -f1)
        # 文本总行数
        total_num=$(cat $bash_profile | wc -l)
        # 文本前缀部分
        text_prefix=$(sed -n "1,$(($start_num - 1))p" $bash_profile)
        # 文本后缀部分
        text_suffix=$(sed -n "$(($start_num + 1)),${total_num}p" $bash_profile)
        # 将追加的文本覆盖原有文件
        cat >$bash_profile <<EOF
${text_prefix}
export PIP_HOME=${dirname_path%/*}
${text_suffix}
EOF
    else
        echo "配置不存在，将文件写入["${bash_profile}"]"
        # 获取关键字的开始行数
        start_num=$(grep -n 'alias zip' $bash_profile | tail -n 1 | cut -d ":" -f1)
        # 文本总行数
        total_num=$(cat $bash_profile | wc -l)
        # 获取关键字“配置eval变量”的开始行数
        eval_num=$(grep -n '配置eval变量' $bash_profile | tail -n 1 | cut -d ":" -f1)
        # 文本前缀部分
        text_prefix=$(sed -n "1,$(($start_num - 1))p" $bash_profile)
        # 文本中间部分
        text_middle=$(sed -n "${start_num},$(($eval_num - 1))p" $bash_profile)
        # 文本后缀部分
        text_suffix=$(sed -n "$(($eval_num)),${total_num}p" $bash_profile)

        # 将追加的文本覆盖原有文件
        cat >$bash_profile <<EOF
${text_prefix}

# 配置pip3安装目录，执行命令：pyenv which pip3
export PIP_HOME=${dirname_path%/*}
alias pip2=$PIP_HOME/bin/pip2
alias pip3=$PIP_HOME/bin/pip3
alias pip=pip3

${text_middle}:\$PIP_HOME/bin

${text_suffix}
EOF
    fi
    source $bash_profile
    return 0
}

echo "---------------函数开始执行---------------"
check_pyenv_virtualenv $1
write_bash_profile
echo "---------------函数执行完毕---------------"
