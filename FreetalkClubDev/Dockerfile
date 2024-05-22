# 使用 php:8.2-fpm 镜像作为基础
FROM php:8.2-fpm

# 更新包管理器并安装必要的依赖
RUN apt-get update && apt upgrade -y && apt-get install -y \
    unzip \
    libbz2-dev \
    libmemcached-dev \
    zlib1g-dev \
    libldap2-dev \
    libpng-dev \
    libpq-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    libxpm-dev \
    libvpx-dev \
    libfreetype6-dev \
    libxml2-dev \
    libicu-dev \ 
    git \   
    curl \
    && apt install -y \
    libmariadb-dev-compat \
    libmariadb-dev \
    libzip-dev \
    libmagickwand-dev \
    imagemagick \
    libmcrypt-dev \
    libmcrypt4 \
    libssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp --with-xpm \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mysqli zip intl exif ldap bcmath opcache bz2 gettext sockets \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
    && docker-php-ext-install -j$(nproc) ldap \
    && pecl install imagick swoole memcached redis \
    && docker-php-ext-enable imagick swoole memcached redis

# 安装 mcrypt 扩展
RUN pecl install mcrypt-1.0.7 \
    && docker-php-ext-enable mcrypt

# 安装 SourceGuardian 扩展
RUN curl -L -o /tmp/loaders.linux-x86_64.tar.gz https://github.com/shakenny/standard-docker/raw/main/loaders.linux-x86_64.tar.gz \
    && tar -zxvf /tmp/loaders.linux-x86_64.tar.gz -C /tmp/ \
    && cp /tmp/ixed.8.2.lin /usr/local/lib/php/extensions/no-debug-non-zts-20220829/ \
    && echo "zend_extension=ixed.8.2.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini \
    && rm /tmp/loaders.linux-x86_64.tar.gz

# 配置 PHP 上传限制和内存限制
RUN echo "upload_max_filesize=50M\npost_max_size=50M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit=512M" > /usr/local/etc/php/conf.d/memory.ini

# 清理包缓存和临时文件
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
