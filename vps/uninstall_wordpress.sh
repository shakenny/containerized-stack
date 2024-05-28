#!/bin/bash

read -r -p "请输入域名: " domain_name

# 使用 sed 将域名中的 . 替换为 _，并生成数据库名
database_name=$(echo "$domain_name" | sed 's/\./_/g')

# 删除Mysql数据库
echo "删除数据库..."
docker exec -e MYSQL_PWD='!Ybw324!' mysql mysql -uroot -e "DROP DATABASE $database_name;"

# 停止Nginx服务器以便申请证书
echo "删除WordPress程序..."
rm -r /home/web/html/"${domain_name}"
rm /home/web/conf.d/"${domain_name}".conf
rm /home/web/certs/"${domain_name}"_key.pem
rm /home/web/certs/"${domain_name}"_cert.pem
docker restart nginx

echo "WordPress卸载完成..."