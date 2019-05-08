#!/bin/bash
## --------------------------------------------------
## Filename:        init.sh
## Revision:        latest stable
## Date:            2019/05/9
## Author:          jason.zhuo
## E-mail:          xiaoyaojiugui520@126.com
## Description:     脚本集合
## --------------------------------------------------
## Copyright (C) 2019 leisure. All rights reserved

echo "备份.bash_profile -->> .bash_profile_bak，防止操作失误回滚"
cat ~/.bash_profile >>~/.bash_profile_bak

echo "授权目录文件，执行命令：chmod 700 ./*/*.sh"
chmod 700 ./*.sh
chmod 700 ./*/install.sh

./homebrew/install.sh
./pyenv/install.sh
./pip/install.sh
