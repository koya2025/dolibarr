# Use an official PHP image with Apache as the base.
FROM php:7.4-apache

# Install system dependencies for PHP extensions.
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql intl bcmath mbstring zip

# Enable Apache mod_rewrite for friendly URLs.
RUN a2enmod rewrite

# Set the working directory.
WORKDIR /var/www/html

# Copy your fork’s source code into the image.
COPY . /var/www/html

# Adjust permissions so Apache can access the files.
RUN chown -R www-data:www-data /var/www/html

# Set environment variables for Dolibarr credentials and configuration.
# You can modify these values to your desired credentials.
ENV DOLI_ADMIN_LOGIN=admin
ENV DOLI_ADMIN_PASSWORD=admin
ENV DOLI_DB_HOST=localhost
ENV DOLI_DB_NAME=dolibarr
ENV DOLI_DB_USER=dolibarr
ENV DOLI_DB_PASSWORD=admin
ENV TZ=Asia/Dubai
ENV LANG=en_US.UTF-8

# Expose Apache's port.
EXPOSE 80

# Start Apache in the foreground.
CMD ["apache2-foreground"]
