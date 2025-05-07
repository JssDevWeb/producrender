#!/bin/bash

# Inicia PHP-FPM en segundo plano
php-fpm &

# Inicia Nginx en primer plano (para que el contenedor no se cierre)
# El flag -g "daemon off;" asegura que Nginx se ejecute en primer plano
nginx -g "daemon off;"

# Nota: Si necesitas ejecutar migraciones u otros comandos al inicio,
# puedes añadirlos aquí antes de iniciar php-fpm y nginx.
# Por ejemplo:
# php artisan migrate --force
