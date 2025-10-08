# This is a Dockerfile for setting up a SuiteCRM environment using PHP 8.1 and Apache.
# This setup is based on SuiteCRM 8.6.0.
# To make the image, you need to download the SuiteCRM source code from SuiteCRM's official repository and place the .Zip file in the same directory as this Dockerfile.
# Then unzip the file and rename the extracted folder to "SuiteCRM".
# Finally, run the command: docker build -t suitecrm:8.6.0 .

FROM php:8.1-apache

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libzip-dev unzip libonig-dev libxml2-dev cron \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli zip opcache mbstring bcmath xml \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# Set Apache DocumentRoot to /var/www/html/public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# set the working directory
WORKDIR /var/www/html

# Enable Apache rewrite module
RUN a2enmod rewrite

# Copy SuiteCRM files (you can also mount them via a volume)
COPY ./SuiteCRM /var/www/html/
#COPY ./config.php /var/www/html/public/legacy/config.php

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose the web server port
EXPOSE 80

# Start Apache
#CMD ["apache2-foreground"]
