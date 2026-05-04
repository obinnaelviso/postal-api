#!/bin/sh
set -eu

cd /app

i=0
until php -r "new PDO('mysql:host=${DB_HOST};port=${DB_PORT:-3306}', '${DB_USERNAME}', '${DB_PASSWORD}');" 2>/dev/null; do
	i=$((i + 1))
	if [ $i -ge 30 ]; then
		echo "DB not reachable after 60s, continuing anyway"
		break
	fi
	echo "Waiting for database at ${DB_HOST}:${DB_PORT:-3306}..."
	sleep 2
done

php artisan config:cache
php artisan route:cache
php artisan migrate --force --graceful

exec "$@"
