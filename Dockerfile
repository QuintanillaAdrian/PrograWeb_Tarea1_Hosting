# Usa una imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y libpng-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql gd

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Copiar primero composer.json y composer.lock para aprovechar la caché de Docker
COPY laravel_hosting/composer.json laravel_hosting/composer.lock ./

# Instalar dependencias de Laravel
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Copiar el resto del proyecto (esto incluye el archivo artisan)
COPY . .

# Dar permisos a la carpeta de almacenamiento y cache
RUN chmod -R 777 storage bootstrap/cache

# Exponer el puerto de Apache
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]
