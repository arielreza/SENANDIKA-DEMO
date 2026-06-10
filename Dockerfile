FROM php:8.3-fpm

# Install system dependencies bawaan Debian + library pendukung GD
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor \
    mariadb-client \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl

# Konfigurasi dan install PHP extensions (Termasuk ZIP, MySQL, dan GD)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql zip gd

# Install nodejs dan npm untuk compiler Vite
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www

# Copy seluruh isi projek
COPY . .

# Buat .env dari template agar Vite dan artisan bisa berjalan saat build
# (Kredensial nyata sudah di-hardcode di config/database.php & config/session.php)
RUN cp .env.example .env

# Install dependencies PHP dan Node
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build

# Setup storage dan bersihkan config cache agar Railway vars bisa masuk
RUN php artisan storage:link --force || true
RUN php artisan config:clear

# Expose port
EXPOSE 80

# Jalankan server
CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]