#!/bin/bash

# 更新系统并安装必要的第三方软件
apt update -y && apt upgrade -y && apt install -y curl wget sudo socat unzip tree

# 安装Docker和Docker Compose
curl -fsSL https://get.docker.com | sh
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# 创建软件所需的目录结构
mkdir -p /home/web/html /home/web/certs /home/web/conf.d
mkdir -p /home/web/mysql/conf.d /home/web/mysql/data /home/web/mysql/log
mkdir -p /home/web/redis/conf /home/web/redis/data /home/web/redis/logs
mkdir -p /home/web/postgresql

# 创建默认证书文件
openssl req -x509 -nodes -newkey rsa:2048 -keyout /home/web/certs/default_server.key -out /home/web/certs/default_server.crt -days 5475 -subj "/C=US/ST=State/L=City/O=Organization/OU=Organizational Unit/CN=Common Name"

# 创建自动续签证书任务
# 切换到一个一致的目录（例如，家目录）
cd ~ || exit

# 下载并使脚本可执行
wget -O ~/.auto_cert_renewal.sh https://raw.githubusercontent.com/shakenny/standard-docker/main/auto_cert_renewal.sh
chmod +x ~/.auto_cert_renewal.sh

# 设置定时任务字符串
cron_job="0 0 * * * ~/.auto_cert_renewal.sh"

# 检查是否存在相同的定时任务
existing_cron=$(crontab -l 2>/dev/null | grep -F "$cron_job")

# 如果不存在，则添加定时任务
if [ -z "$existing_cron" ]; then
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
    echo "续签任务已添加"
else
    echo "续签任务已存在，无需添加"
fi

# 下载配置文件
wget -O /home/web/nginx.conf https://raw.githubusercontent.com/shakenny/standard-docker/main/nginx.conf
wget -O /home/web/conf.d/default.conf https://raw.githubusercontent.com/shakenny/standard-docker/main/default.conf

wget -O /home/web/mysql/conf.d/my.cnf https://raw.githubusercontent.com/shakenny/standard-docker/main/my.cnf
wget -O /home/web/mysql/conf.d/init.sql https://raw.githubusercontent.com/shakenny/standard-docker/main/vps/init.sql

wget -O /home/web/redis/conf/redis.conf https://raw.githubusercontent.com/redis/redis/7.2/redis.conf

# 修改Redis配置文件
sed -i "s/bind 127.0.0.1 -::1/bind 0.0.0.0/g" /home/web/redis/conf/redis.conf
sed -i "s/# requirepass foobared/requirepass \!Ybw324\!/g" /home/web/redis/conf/redis.conf
sed -i "s/appendonly no/appendonly yes/g" /home/web/redis/conf/redis.conf

# 下载Docker Compose文件和Dockerfile
wget -O /home/web/docker-compose.yml https://raw.githubusercontent.com/shakenny/standard-docker/main/vps/docker-compose.yml
wget -O /home/web/Dockerfile https://raw.githubusercontent.com/shakenny/standard-docker/main/vps/Dockerfile

echo "Initialization script completed successfully."
