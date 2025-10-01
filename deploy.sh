#!/bin/bash

# GoDaddy Deployment Script
# This script should be placed on your GoDaddy server

PROJECT_PATH="/home/your-username/public_html/your-project"
BACKUP_PATH="/home/your-username/backups"

echo "Starting deployment..."

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_PATH

# Create a backup of the current deployment
BACKUP_NAME="backup_$(date +%Y%m%d_%H%M%S)"
echo "Creating backup: $BACKUP_NAME"
cp -r $PROJECT_PATH $BACKUP_PATH/$BACKUP_NAME

# Navigate to project directory
cd $PROJECT_PATH

# Put application in maintenance mode
php artisan down

# Pull latest changes from git
echo "Pulling latest changes..."
git pull origin main

# Install/Update composer dependencies
echo "Installing composer dependencies..."
composer install --no-dev --optimize-autoloader --no-interaction

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    echo "Copying .env.example to .env"
    cp .env.example .env
    echo "Please update .env file with your production settings"
fi

# Clear all cached config, routes, and views
echo "Clearing caches..."
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Run database migrations
echo "Running database migrations..."
php artisan migrate --force

# Cache config, routes, and views for better performance
echo "Caching application..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Create storage symlink
echo "Creating storage symlink..."
php artisan storage:link

# Set proper permissions
echo "Setting permissions..."
find $PROJECT_PATH -type f -exec chmod 644 {} \;
find $PROJECT_PATH -type d -exec chmod 755 {} \;
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# Remove application from maintenance mode
php artisan up

echo "Deployment completed successfully!"
echo "Backup created at: $BACKUP_PATH/$BACKUP_NAME"
