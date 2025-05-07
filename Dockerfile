FROM php:8.3-fpm

# Instala dependencias necesarias para PHP y Node.js
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libpq-dev \
    libzip-dev \
    nodejs \
    npm \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia el proyecto Laravel
WORKDIR /var/www
COPY . .

# Instala dependencias del proyecto PHP con Composer
RUN composer install --no-dev --optimize-autoloader

# Instala dependencias del proyecto Node.js con npm (o yarn si lo usas)
RUN npm install


# Genera APP_KEY y enlaces de storage
RUN php artisan key:generate
RUN php artisan storage:link || true

# Exposición del puerto para PHP server
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000

# Ejecuta el build de Vite para compilar los assets frontend
RUN npm run build


