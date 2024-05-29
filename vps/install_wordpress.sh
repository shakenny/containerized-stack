#!/bin/bash

clear
# 获取php版本
php1_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
php2_version=$(docker exec php74 php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")

echo "                现有PHP信息                "
echo "---------------------------------------------------"
echo -n "       1) php : v$php1_version"
echo -n "       2) php : v$php2_version"
echo ""
echo "---------------------------------------------------"
read -r -p "请输入域名: " domain_name
read -r -p "请输入你选择的PHP版本: " choice
case $choice in
  1)
    ## 下载配置Wordpress的Nginx配置文件
    echo "配置WordPress的Nginx文件"
    wget -O /home/web/conf.d/"${domain_name}".conf https://raw.githubusercontent.com/shakenny/standard-docker/main/vps/wordpress.conf
    sed -i "s/yuming.com/$domain_name/g" /home/web/conf.d/"${domain_name}".conf
    ;;
  2)
    ## 下载配置Wordpress的Nginx配置文件
    echo "配置WordPress的Nginx文件"
    wget -O /home/web/conf.d/"${domain_name}".conf https://raw.githubusercontent.com/shakenny/standard-docker/main/vps/wordpress.conf
    sed -i "s/yuming.com/$domain_name/g" /home/web/conf.d/"${domain_name}".conf
    sed -i "s/php:9000/php74:9000/g" /home/web/conf.d/"${domain_name}".conf
    ;;
  *)
    echo "无效选择！！"
    ;;
esac

# 使用 sed 将域名中的 . 替换为 _，并生成数据库名
database_name=$(echo "$domain_name" | sed 's/\./_/g')

# 停止Nginx服务器以便申请证书
echo "Nginx停止..."
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

# 根据域名创建相应的Mysql数据库
echo "创建数据库..."
docker exec -e MYSQL_PWD='!Ybw324!' mysql mysql -uroot -e "CREATE DATABASE $database_name; GRANT ALL PRIVILEGES ON $database_name.* TO 'kennyyang'@'%';"

## 下载安装WordPress源码包
echo "下载WordPress，并安装..."
cd /home/web/html || exit
mkdir "${domain_name}"
cd "${domain_name}" || exit
wget -O latest.zip https://cn.wordpress.org/latest-zh_CN.zip
unzip latest.zip
rm latest.zip


# 要插入的命令
insert_commands="define('FS_METHOD', 'direct');\ndefine('WP_REDIS_HOST', 'redis');\ndefine('WP_REDIS_PORT', '6379');"

# 使用 sed 插入命令
sed -i "/\/\* 在这行和「停止编辑」行之间添加任何自定义值。 \*\//a\\ ${insert_commands}" "/home/web/html/"${domain_name}"/wordpress/wp-config-sample.php"

# 重启Nginx服务器
echo "Nginx启动"
docker start nginx

docker exec nginx chmod -R 777 /var/www/html && docker exec php chmod -R 777 /var/www/html && docker exec php74 chmod -R 777 /var/www/html

echo "WordPress安装完成"
