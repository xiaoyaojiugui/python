# 这是一个自动创建脚本
basepath=$(
    cd $(dirname $0)
    pwd
)

# 创建文件
rootpath=~/.pip
path_names=(${rootpath})
for path in ${path_names[@]}; do
    if [ ! -d $path ]; then
        echo "创建文件夹["${path}"]"
        mkdir -p -v ${path}
    else
        echo "文件夹["${path}"]已经存在"
    fi
done

# 拷贝文件到指定目录
cd ${rootpath} && touch pip.conf
echo "将阿里云pip国内镜像配置在如下文件内["$(ls *)"]"
cat >pip.conf <<EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host=mirrors.aliyun.com
EOF
cat pip.conf

echo "用pip3命令批量安装包，，执行命令：pip3 install -r ./requirements.txt"
cd $basepath && pip3 install -r ./requirements.txt
