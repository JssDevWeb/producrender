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
    && rm -rf /var/lib/apt/lists/*

# Instala extensiones de PHP (asegurando pdo_pgsql)
RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql mbstring zip exif pcntl bcmath gd

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia el proyecto Laravel
WORKDIR /var/www
COPY . .

# Instala dependencias del proyecto PHP con Composer
RUN composer install --no-dev --optimize-autoloader

# Instala dependencias de Node.js con npm (o yarn si lo usas)
RUN npm install

# Ejecuta el build de Vite para compilar los assets frontend
RUN npm run build

# --- Añade este paso para asegurar que el autoloader esté listo ---
RUN composer dump-autoload --optimize

# Genera APP_KEY
RUN php artisan key:generate --force

# --- CAMBIO IMPORTANTE AQUÍ ---
# En lugar de crear un enlace simbólico, copia directamente el contenido de storage/app/public a public/storage
# Asegúrate de que la carpeta public/storage exista antes de copiar
RUN mkdir -p public/storage
RUN cp -R storage/app/public/* public/storage/ || true # Usa || true para evitar que falle si la carpeta public está vacía

# Limpia caches de Laravel (opcional pero recomendado)
RUN php artisan config:clear
RUN php artisan route:clear
RUN php artisan view:clear

# Exposición del puerto para PHP server
EXPOSE 8000

# Comando para ejecutar la aplicación
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=8000
