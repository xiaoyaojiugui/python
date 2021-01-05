#!/bin/bash
## --------------------------------------------------
## Filename:        install.sh
## Revision:        latest stable
## Date:            2019/05/08
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     主要用于配置pip.conf、代理国内镜像（默认阿里云）、批量安装常用pip包（requirements.txt）
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved

basepath=$(
    cd $(dirname $0)
    pwd
)
echo "---------------脚本位置["${basepath}"]---------------"

rootpath=~/.pip
# 创建文件
function create_file() {
    path_names=(${rootpath})
    for path in ${path_names[@]}; do
        if [ ! -d $path ]; then
            echo "1、创建文件夹["${path}"]"
            mkdir -p -v ${path}
        else
            echo "1、文件夹已存在["${path}"]"
        fi
    done
    return 0
}

# 将阿里云pip国内镜像写到目录
function write_mirror() {
    file_name="pip.conf"
    cd ${rootpath}
    if [ -f $file_name ]; then
        echo "2、文件已存在["${rootpath}/$file_name"]"
        return 0
    else
        touch $file_name
        echo "2、将阿里云pip国内镜像的配置，写在文件["$(ls *)"]中"
        cat >$file_name <<EOF
[global]
index-url = https://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
[list]
format = columns
EOF
        cat $file_name
    fi
    return 0
}

# 将配置文件写入.bash_profile
function write_bash_profile() {
    #获取pip安装路径
    soft_link="/usr/local/bin/pip3"
    relative_path=$(pyenv which pip3)
    if [ -f $soft_link ]; then
        echo "3、软链接已存在[${soft_link}]，无需重复创建"
    else
        echo "3、创建软链接，执行命令：ln -s $relative_path $soft_link"
        ln -s $relative_path $soft_link
    fi

    # 获取配置文件路径
    bash_profile=$HOME"/"$(basename ~/.bash_profile)
    # 判断需要添加的配置是否存在
    alias_name=$(grep -w 'export PIP_HOME' $bash_profile)
    if [ ! -z "$alias_name" ]; then
        echo "4、配置信息已存在["${alias_name}"]"
    else
        echo "4、查看python安装路径，$(dirname $relative_path)"
        dirname_path=$(dirname $relative_path)

        echo "5、配置信息不存在，将文件写入["${bash_profile}"]"
        # 获取根据关键字查询的行数，开始行数
        start_num=$(grep -n 'alias zip' $bash_profile | tail -n 1 | cut -d ":" -f1)
        # 文本总行数
        total_num=$(cat $bash_profile | wc -l)
        # 配置eval的开始行数
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
        source $bash_profile
    fi
    return 0
}

function install_pip_txt() {
    exist=$(pip3 --version)
    # 用(echo $?)取得上一条命令的返回值并判断，Linux中0表示True，非0表示False。
    exec_status=$(echo $?)
    if [ $exec_status == "0" ]; then
        echo "更新pip3仓库为最新版本，执行命令：pip3 install --upgrade pip"
        pip3 install --upgrade pip

        echo "用pip3命令批量安装包，执行命令：pip3 install -r ./requirements.txt"
        cd $basepath && pip3 install -r ./requirements.txt
        # 安装完成后，更新数据库
        pyenv rehash
    else
        echo "执行(pip3 --version)命令时，未检查到python3请先安装"
    fi
    return 0
}

echo "---------------函数开始执行---------------"
create_file
write_mirror
write_bash_profile
# install_pip_txt
echo "---------------函数执行完毕---------------"
