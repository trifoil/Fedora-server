FROM php:7.4-apache

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client

# Install mysqli PHP extension
RUN docker-php-ext-install mysqli

COPY index.php /var/www/html/
COPY style.css /var/www/html/
COPY logo.png /var/www/html/
