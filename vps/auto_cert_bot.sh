#!/bin/bash

# 切换到一个一致的目录（例如，家目录）
cd ~ || exit

# 下载并使脚本可执行
curl -O https://raw.githubusercontent.com/kejilion/sh/main/auto_cert_renewal.sh
chmod +x auto_cert_renewal.sh

# 设置定时任务字符串
cron_job="0 0 * * * ~/auto_cert_renewal.sh"

# 检查是否存在相同的定时任务
existing_cron=$(crontab -l 2>/dev/null | grep -F "$cron_job")

# 如果不存在，则添加定时任务
if [ -z "$existing_cron" ]; then
    (crontab -l 2>/dev/null; echo "$cron_job") | crontab -
    echo "续签任务已添加"
else
    echo "续签任务已存在，无需添加"
fi