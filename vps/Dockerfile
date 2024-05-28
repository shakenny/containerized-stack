# 设置 PHP 版本作为构建参数
ARG PHP_VERSION
FROM php:${PHP_VERSION}-fpm

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

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
    && pecl install imagick memcached redis \
    && docker-php-ext-enable imagick memcached redis

# 安装 mcrypt 扩展
RUN if [ "${PHP_VERSION}" = "8.2" ]; then \
        pecl install mcrypt-1.0.7 && docker-php-ext-enable mcrypt; \
    elif [ "${PHP_VERSION}" = "7.4" ]; then \
        pecl install mcrypt-1.0.4 && docker-php-ext-enable mcrypt; \
    fi

# 安装 swoole 扩展
RUN if [ "${PHP_VERSION}" = "8.2" ]; then \
        pecl install swoole && docker-php-ext-enable swoole; \
    elif [ "${PHP_VERSION}" = "7.4" ]; then \
        pecl install swoole-4.8.11 && docker-php-ext-enable swoole; \
    fi

# 安装 SourceGuardian 扩展
RUN if [ "${PHP_VERSION}" = "8.2" ]; then \
        curl -L -o /tmp/loaders.linux-x86_64.tar.gz https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz \
        && tar -zxvf /tmp/loaders.linux-x86_64.tar.gz -C /tmp/ \
        && cp /tmp/ixed.8.2.lin /usr/local/lib/php/extensions/no-debug-non-zts-20220829/ \
        && echo "zend_extension=ixed.8.2.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini \
        && rm -rf /tmp/loaders.linux-x86_64.tar.gz; \
    elif [ "${PHP_VERSION}" = "7.4" ]; then \
        curl -L -o /tmp/loaders.linux-x86_64.tar.gz https://www.sourceguardian.com/loaders/download/loaders.linux-x86_64.tar.gz \
        && tar -zxvf /tmp/loaders.linux-x86_64.tar.gz -C /tmp/ \
        && cp /tmp/ixed.7.4.lin /usr/local/lib/php/extensions/no-debug-non-zts-20190902/ \
        && echo "zend_extension=ixed.7.4.lin" > /usr/local/etc/php/conf.d/sourceguardian.ini \
        && rm -rf /tmp/loaders.linux-x86_64.tar.gz; \
    fi

# 配置 PHP 上传限制和内存限制
RUN echo "upload_max_filesize=80M\n post_max_size=100M" > /usr/local/etc/php/conf.d/uploads.ini \
    && echo "memory_limit=256M" > /usr/local/etc/php/conf.d/memory.ini

# 清理包缓存和临时文件
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
