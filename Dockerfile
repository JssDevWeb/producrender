# Etapa 1: Build de la aplicación (PHP, Composer, NPM/Vite)
FROM php:8.3-fpm as builder

# Instala dependencias del sistema necesarias para PHP y Node.js
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
    && rm -rf /var/lib/apt/lists/*

# Instala extensiones de PHP (asegurando pdo_pgsql)
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia el código fuente de la aplicación
WORKDIR /app
COPY . /app

# Instala dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Instala dependencias de Node.js y compila assets (Vite)
RUN npm install
RUN npm run build

# --- Añade este paso para copiar .env.example a .env ---
# Esto asegura que el archivo .env exista para php artisan key:generate
RUN cp .env.example .env || true # Usa || true por si .env.example no existe (aunque debería)

# Genera APP_KEY
RUN php artisan key:generate --force

# Crea el enlace simbólico de storage (Nginx lo manejará correctamente)
RUN php artisan storage:link

# Limpia caches de Laravel (opcional pero recomendado para producción)
RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

# Etapa 2: Configuración final con Nginx
# Usamos una imagen base ligera de Nginx (alpine es eficiente)
FROM nginx:alpine

# Copia los archivos de la aplicación desde la etapa builder a la ubicación de Nginx
COPY --from=builder /app /var/www/html

# Elimina la configuración por defecto de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copia la configuración personalizada de Nginx que creaste en el Paso 1
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expone el puerto 80 (Render lo usará para dirigir el tráfico)
EXPOSE 80

# El comando de inicio se definirá en Render para ejecutar Nginx y PHP-FPM
CMD ["nginx", "-g", "daemon off;"]
