#!/bin/bash

set -e
set -o pipefail

APP_DIR=/var/www/laravel-app
REPO_DIR=$APP_DIR/releases/$(date +%Y%m%d%H%M%S)
CURRENT_DIR=$APP_DIR/current

echo "[INFO] Deploying new release to $REPO_DIR"

mkdir -p $REPO_DIR
cd $REPO_DIR
git clone https://github.com/YOUR_USERNAME/laravel-ec2-cicd.git .

composer install --no-dev --optimize-autoloader
cp $APP_DIR/.env .env
php artisan migrate --force
php artisan config:cache
php artisan route:cache
php artisan view:cache

ln -sfn $REPO_DIR $CURRENT_DIR
chown -R www-data:www-data $APP_DIR

systemctl reload php8.2-fpm
systemctl reload nginx

echo "[SUCCESS] Deployment completed."
