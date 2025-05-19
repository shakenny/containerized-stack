cd ~ || exit
wget -O ~/.init_env.sh https://raw.githubusercontent.com/shakenny/containerized-stack/refs/heads/main/local/init_env.sh
chmod +x ~/.init_env.sh

~/.init_env.sh