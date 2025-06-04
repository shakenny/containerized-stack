#!/bin/bash

read -r -p "请输入域名: " domain_name
read -r -p "请输入反代理IP地址: " ip_address
read -r -p "请输入反代理端口: " port

# 设置Cloudflare API环境变量
export CF_Token="NXCgZOt0DDuYdQ59ehyeR-wPFffxIotr1qO2oqSv"  
export CF_Account_ID="3b1306fed3472419f830e0cf96cb85ce"  
source ~/.bashrc

# 安装acme.sh（必须先安装）
echo "正在安装 acme.sh 脚本..."
curl https://get.acme.sh | sh
source ~/.bashrc  # 刷新环境变量

# 注册账户（只需执行一次）
echo "正在注册账户..."
~/.acme.sh/acme.sh --register-account -m admin@digitaluniverse.pro

# 使用DNS验证申请证书（关键步骤）
echo "正在使用DNS验证签发证书..."
~/.acme.sh/acme.sh --issue --dns dns_cf -d "$domain_name" --keylength ec-256 # ECC证书更高效

# 安装证书到指定位置
echo "正在安装证书..."
~/.acme.sh/acme.sh --installcert -d "$domain_name" --key-file /home/web/certs/"${domain_name}"_key.pem --fullchain-file /home/web/certs/"${domain_name}"_cert.pem
echo "证书签发安装操作完成。"

# 关键改进2：安装自动续期任务
echo "安装自动续期任务..."
~/.acme.sh/acme.sh --install-cronjob

# 验证定时任务
echo "当前定时任务："
crontab -l | grep acme

echo "配置反向代理配置文件..."
wget -O /home/web/conf.d/"$domain_name".conf https://raw.githubusercontent.com/kejilion/nginx/main/reverse-proxy-template.conf
sed -i "s/yuming.com/$domain_name/g" /home/web/conf.d/"$domain_name".conf
sed -i "s/0.0.0.0/$ip_address/g" /home/web/conf.d/"$domain_name".conf
sed -i "s/0000/$port/g" /home/web/conf.d/"$domain_name".conf
echo "配置完成"
