
# 1. Mac自动化安装python应用

## 1.1. 项目结构
```
.
└── env
    ├── homebrew    主要安装管理工具homebrew、代理国内镜像（默认配置清华大学开源软件镜像站）
    ├── pip         主要用于配置pip.conf、代理国内镜像（默认阿里云）、批量安装常用pip包（requirements.txt）
    └── pyenv       主要用于管理多版本python（默认python-3.6.5）、配置python环境变量
```


## 1.2. 安装说明
* Shell文件[init.sh]是初始化脚本，其将env目录下所有可执行的[./\*/install.sh]都打包在其中，在终端运行命令（sh ./init.sh）即可启动脚本，脚本执行时默认会给相应的目录授权，详情看脚本[init.sh](https://github.com/xiaoyaojiugui/python/blob/master/env/init.sh)
* 执行[init.sh]时，首先确保本地的（~/.bash_profile）文件与样例[bash_profile](https://github.com/xiaoyaojiugui/python/blob/master/env/docs/bash_profile)结构是否类似，如有差异请参考样例修改
* 执行脚本改动环境变量时，只会修改红色部分<br>
执行前如图所求：
![image](https://github.com/xiaoyaojiugui/python/blob/master/env/docs/image/bash_profile.jpg)
执行后如图所求：
![image](https://github.com/xiaoyaojiugui/python/blob/master/env/docs/image/bash_profile_after.jpg)
## 1.3. 使用pyenv与pyenv-virtualenv管理python环境
* pyenv：解决的是同一个系统中不同版本的 python 并存的问题
* pyenv-virtualenv：解决的是不同项目所依赖的软件包之间可能产生冲突的问题
> 在实际使用 python 的过程中，很容易出现这样的问题：<br>
> 通过pip安装软件包 A 时安装了 A 所依赖的软件包 B；之后又通过pip安装软件包 C 时再次安装了 B 并将之前的覆盖，但是因为 C 和 A 所依赖的 B 版本不同，安装完 C 后导致 A 无法运行。

## 1.4. requirements功能说明
#### 1.4.0.1. 科学计算
> NumPy 应用
* NumPy通常与SciPy（Scientific Python）和Matplotlib（绘图库）一起使用， 这种组合广泛用于替代MatLab，是一个强大的科学计算环境，有助于我们通过 Python 学习数据科学或者机器学习。
* SciPy包含的模块有最优化、线性代数、积分、插值、特殊函数、快速傅里叶变换、信号处理和图像处理、常微分方程求解和其他科学与工程中常用的计算。
* Matplotlib是Python编程语言及其数值数学扩展包NumPy的可视化操作界面。它为利用通用的图形用户界面工具包，如Tkinter,wxPython, Qt或GTK+向应用程序嵌入式绘图提供了应用程序接口（API）。