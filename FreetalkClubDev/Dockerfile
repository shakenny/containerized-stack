# 使用 php:8.2-fpm 镜像作为基础
FROM php:8.2-fpm

# 更新包管理器并安装必要的依赖
RUN apt-get update && apt-get install -y \
    libzip-dev \
    unzip \
    libmemcached-dev \
    zlib1g-dev \
    libldap2-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mysqli gd zip

# 安装 Redis 扩展
RUN pecl install redis && docker-php-ext-enable redis

# 清理缓存
RUN apt-get clean && rm -rf /var/lib/apt/lists/*