#!/bin/bash

clear
# 获取php版本
php1_version=$(docker exec php php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")
php2_version=$(docker exec php74 php -v 2>/dev/null | grep -oP "PHP \K[0-9]+\.[0-9]+\.[0-9]+")

echo "                现有PHP信息                "
echo "------------------------------------------"
echo -n "       1) php : v$php1_version"
echo -n "       2) php : v$php2_version"
echo ""
echo "------------------------------------------"
read -r -p "请输入域名: " domain_name

# 使用 sed 将域名中的 . 替换为 _，并生成数据库名
database_name=$(echo "$domain_name" | sed 's/\./_/g')

read -r -p "请输入你的选择: " choice
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
esac
