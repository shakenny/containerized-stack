#!/bin/bash

read -r -p "请输入域名: " domain_name
read -r -p "请输入代理端口: " port

# 停止Nginx服务器以便申请证书
docker stop nginx

# 申请证书
echo "正在安装 acme.sh 脚本..."
curl https://get.acme.sh | sh
echo "正在注册账户..."
~/.acme.sh/acme.sh --register-account -m xxxx@gmail.com
echo "正在签发证书..."
~/.acme.sh/acme.sh --issue -d "$domain_name" --standalone

# 下载证书
echo "正在安装证书..."
~/.acme.sh/acme.sh --installcert -d "$domain_name" --key-file /home/web/certs/"${domain_name}"_key.pem --fullchain-file /home/web/certs/"${domain_name}"_cert.pem
echo "证书签发安装操作完成。"

echo "配置反向代理配置文件..."
wget -O /home/web/conf.d/"$domain_name".conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy.conf
sed -i "s/yuming.com/$domain_name/g" /home/web/conf.d/"$domain_name".conf
sed -i "s/0.0.0.0/www.freetalkclub.com/g" /home/web/conf.d/"$domain_name".conf
sed -i "s/0000/$port/g" /home/web/conf.d/"$domain_name".conf
echo "配置完成"

# 重启Nginx服务器
docker start nginx
