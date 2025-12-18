FROM php:8.2-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
  libzip-dev \
  zip \
  unzip \
  git \
  curl \
  vim \
  openssl \
  && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install \
  pdo \
  pdo_mysql \
  mysqli \
  zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Copy LegiScan application files
COPY legiscan/ /var/www/html/

# Create necessary directories with proper permissions
RUN mkdir -p \
  /var/www/html/cache/api \
  /var/www/html/cache/doc \
  /var/www/html/log \
  /var/www/html/signal \
  && chown -R www-data:www-data /var/www/html \
  && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
