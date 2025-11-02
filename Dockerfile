# This is a Dockerfile for setting up a SuiteCRM environment using PHP 8.1 and Apache.
# This setup is based on SuiteCRM 8.6.0.
# To make the image, you need to download the SuiteCRM source code from SuiteCRM's official repository and place the .Zip file in the same directory as this Dockerfile.
# Then unzip the file and rename the extracted folder to "SuiteCRM".
# Finally, run the command: docker build -t suitecrm:8.6.0 .

FROM php:8.0-apache

# Configure PHP settings by making a custom ini file.
RUN echo "upload_max_filesize = 64M" > /usr/local/etc/php/conf.d/custom.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "date.timezone = CET" >> /usr/local/etc/php/conf.d/custom.ini
# RUN echo "extension=imap" > /usr/local/etc/php/conf.d/imap.ini

# Install system dependencies and PHP extensions
# RUN apt-get update && apt-get install -y libpng-dev
# RUN apt-get update && apt-get install -y libjpeg-dev
# RUN apt-get update && apt-get install -y libfreetype6-dev
# RUN apt-get update && apt-get install -y libzip-dev
# RUN apt-get update && apt-get install -y unzip
# RUN apt-get update && apt-get install -y libonig-dev
# RUN apt-get update && apt-get install -y libxml2-dev
# RUN apt-get update && apt-get install -y libldap2-dev
# RUN apt-get update && apt-get install -y cron
# RUN apt-get update && apt-get install -y zip
# RUN apt-get update && apt-get install -y libicu-dev
# RUN apt-get update && apt-get install -y icu-devtools
# RUN docker-php-ext-configure gd --with-freetype --with-jpeg 
# RUN  docker-php-ext-configure ldap
# RUN docker-php-ext-install gd ldap mysqli zip opcache mbstring bcmath xml intl soap pdo pdo_mysql
# RUN apt-get clean
# RUN rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    libonig-dev \
    libxml2-dev \
    libldap2-dev \
    cron \
    zip \
    libicu-dev \
    icu-devtools \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-configure ldap \
&& docker-php-ext-install gd ldap mysqli zip opcache mbstring bcmath xml intl soap pdo pdo_mysql \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
/etc/apache2/sites-available/*.conf \
/etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Set Apache DocumentRoot to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

# set the working directory
WORKDIR /var/www/html

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy SuiteCRM files (you can also mount them via a volume)
COPY ./SuiteCRM /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

COPY docker-entrypoint.sh /var/www/html/docker-entrypoint.sh
RUN chmod +x /var/www/html/docker-entrypoint.sh

ENTRYPOINT ["/var/www/html/docker-entrypoint.sh"]


# Expose the web server port
EXPOSE 80



# Start Apache
CMD ["apache2-foreground"]
