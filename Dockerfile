# Usa una imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y libpng-dev zip unzip \
    && docker-php-ext-install pdo pdo_mysql gd

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Copiar todo el contenido de laravel_hosting al contenedor
COPY laravel_hosting/ /var/www/html/

# Copiar primero composer.json y composer.lock para aprovechar la caché de Docker
COPY laravel_hosting/composer.json laravel_hosting/composer.lock /var/www/html/

# Instalar dependencias de Laravel
RUN COMPOSER_ALLOW_SUPERUSER=1 composer install --no-dev --optimize-autoloader

# Dar permisos a la carpeta de almacenamiento y cache
RUN chmod -R 777 storage bootstrap/cache

# Configurar Apache para que sirva desde el directorio public de Laravel
RUN echo '<VirtualHost *:80>' > /etc/apache2/sites-available/000-default.conf \
       && echo '    DocumentRoot /var/www/html/public' >> /etc/apache2/sites-available/000-default.conf \
       && echo '    <Directory /var/www/html/public>' >> /etc/apache2/sites-available/000-default.conf \
       && echo '        AllowOverride All' >> /etc/apache2/sites-available/000-default.conf \
       && echo '        Require all granted' >> /etc/apache2/sites-available/000-default.conf \
       && echo '    </Directory>' >> /etc/apache2/sites-available/000-default.conf \
       && echo '</VirtualHost>' >> /etc/apache2/sites-available/000-default.conf

       
# Habilitar mod_rewrite en Apache
RUN a2enmod rewrite

# Exponer el puerto de Apache
EXPOSE 80

# Comando de inicio
CMD ["apache2-foreground"]
