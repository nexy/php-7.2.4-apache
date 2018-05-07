FROM php:7.2.4-apache
MAINTAINER Ricardo Coelho <ricardo@nexy.com.br>

RUN a2enmod rewrite
RUN apt-get update
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install --no-install-recommends -y \
        git \
        libpq-dev \
        libicu-dev \
        libcurl4-openssl-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxslt1-dev \
        libfontconfig1 \
        libxrender1 \
        libxext6 \
        libldb-dev \
        libldap2-dev
ENV DEBIAN_FRONTEND teletype
RUN docker-php-ext-install -j$(nproc) pgsql pdo_pgsql pdo_mysql ldap xsl gettext mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd intl zip
RUN pecl install mcrypt-1.0.1 \
    && docker-php-ext-enable mcrypt
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
chmod +x /usr/local/bin/composer
COPY assets/wkhtmltopdf /usr/bin/
