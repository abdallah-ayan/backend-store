# استخدم صورة PHP الرسمية مع Apache
FROM php:8.2-apache

# تنصيب الإضافات المطلوبة للـ Laravel
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd

# تنصيب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات Laravel إلى مجلد Apache
COPY . /var/www/html

# إعداد Apache للعمل مع Laravel
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# إعداد العمل داخل مجلد Laravel
WORKDIR /var/www/html

# تثبيت الـ dependencies
RUN composer install --no-dev --optimize-autoloader

# إعداد Laravel
RUN cp .env.example .env && php artisan key:generate

EXPOSE 80
CMD ["apache2-foreground"]
