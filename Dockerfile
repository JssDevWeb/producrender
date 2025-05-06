FROM php:8.3-fpm

# Instala dependencias necesarias
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
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia el proyecto Laravel
WORKDIR /var/www
COPY . .

# Instala dependencias del proyecto
RUN composer install --no-dev --optimize-autoloader

# Genera APP_KEY y enlaces
RUN php artisan key:generate && \
    php artisan storage:link || true

# Exposición del puerto para PHP server
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000



services:
  - type: web
    name: laraclient
    env: docker
    plan: free
    repo: https://github.com/tuusuario/tu-repo
    branch: master
    rootDir: .
    dockerfilePath: Dockerfile
    buildCommand: ""
    startCommand: ""
    envVars:
      - key: APP_ENV
        value: production
      - key: APP_KEY
        generateValue: true