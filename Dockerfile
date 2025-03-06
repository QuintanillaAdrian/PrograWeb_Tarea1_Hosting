# Usa una imagen oficial de PHP con Apache
FROM php:8.1-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y libpng-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql gd

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Copiar archivos del proyecto
COPY . /var/www/html


# Copiar primero composer.json y composer.lock (para mejorar caché de Docker)
COPY composer.json composer.lock ./larvel_hosting/

COPY composer.json ./larvel_hosting/

# Instalar dependencias de Laravel
RUN composer install --no-dev --optimize-autoloader

# Ahora copiamos el resto del proyecto
COPY . . 

# Dar permisos a la carpeta de almacenamiento y cache
RUN chmod -R 777 storage bootstrap/cache

# Exponer el puerto de Apache
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]
