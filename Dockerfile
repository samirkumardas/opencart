FROM php:8.0-apache
MAINTAINER Samir <opencartmart@gmail.com>

RUN a2enmod rewrite headers

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    zip \ 
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev

# configure and install php extension
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# install other php extenions without configuration
RUN docker-php-ext-install zip pdo_mysql mysqli

# pecl extenions add and enable
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Clear package lists
RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

# Copy source files
COPY ./upload /var/www/html

RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html
EXPOSE 80