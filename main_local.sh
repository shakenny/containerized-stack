# 第1步：下载init_env.sh
cd ~ || exit
wget -O ~/.init_env.sh https://raw.githubusercontent.com/shakenny/containerized-stack/refs/heads/main/local/init_env.sh
chmod +x ~/.init_env.sh

# 第2步：执行init_env.sh
~/.init_env.sh

# 第3步：运行docker-compose，安装必要容器服务
cd /home/app
docker compose up -d