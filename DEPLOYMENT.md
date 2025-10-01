# GoDaddy Deployment Guide

This guide will help you set up automatic deployment from GitHub to your GoDaddy shared hosting server.

## Prerequisites

1. **GoDaddy Shared Hosting** with SSH access enabled
2. **Git** installed on your GoDaddy server
3. **Composer** installed on your GoDaddy server
4. **PHP 8.1+** available on your server
5. **MySQL database** created on GoDaddy

## Setup Instructions

### 1. Prepare Your GoDaddy Server

#### Enable SSH Access

1. Log into your GoDaddy account
2. Go to your hosting dashboard
3. Enable SSH access (usually in Advanced settings)
4. Note your SSH credentials

#### Install Git and Composer (if not available)

```bash
# Connect to your server via SSH
ssh username@your-server-ip

# Check if git is available
git --version

# Check if composer is available
composer --version

# If composer is not available, install it
curl -sS https://getcomposer.org/installer | php
mv composer.phar /home/your-username/bin/composer
```

### 2. Clone Your Repository on GoDaddy

```bash
# Navigate to your public_html or desired directory
cd /home/your-username/public_html

# Clone your repository
git clone https://github.com/ronnielsajol/pll-app-backend.git your-project-name

# Navigate to project directory
cd your-project-name

# Install dependencies
composer install --no-dev --optimize-autoloader

# Copy environment file
cp .env.production .env

# Generate application key
php artisan key:generate

# Set permissions
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# Create storage symlink
php artisan storage:link
```

### 3. Configure Environment Variables

Edit the `.env` file on your server:

```bash
nano .env
```

Update these critical values:

-   `APP_URL` - Your domain URL
-   `DB_*` - Your GoDaddy database credentials
-   `APP_KEY` - Generate using `php artisan key:generate`

### 4. Setup GitHub Secrets

In your GitHub repository, go to Settings > Secrets and Variables > Actions, and add these secrets:

-   `GODADDY_HOST` - Your server IP or hostname
-   `GODADDY_USERNAME` - Your SSH username
-   `GODADDY_PASSWORD` - Your SSH password (or use SSH keys)
-   `GODADDY_PORT` - SSH port (usually 22)
-   `GODADDY_PROJECT_PATH` - Full path to your project on the server

Example values:

```
GODADDY_HOST: 123.456.789.012
GODADDY_USERNAME: your-username
GODADDY_PASSWORD: your-ssh-password
GODADDY_PORT: 22
GODADDY_PROJECT_PATH: /home/your-username/public_html/your-project-name
```

### 5. Configure Domain (Optional)

If you want your Laravel app to be the main site:

#### Option A: Main Domain

Move the contents of the `public` folder to `public_html`:

```bash
cd /home/your-username/public_html/your-project-name
mv public/* ../
mv public/.* ../
```

Update `index.php` in `public_html` to point to your project:

```php
require __DIR__.'/your-project-name/vendor/autoload.php';
$app = require_once __DIR__.'/your-project-name/bootstrap/app.php';
```

#### Option B: Subdomain

Create a subdomain in GoDaddy and point it to your project's `public` folder.

### 6. Database Setup

1. Create a MySQL database in your GoDaddy hosting panel
2. Update your `.env` file with the database credentials
3. Run migrations:

```bash
php artisan migrate --force
```

## Deployment Process

Once everything is set up, the deployment process is automatic:

1. **Push to main branch** - Any push to the main branch triggers deployment
2. **GitHub Action runs** - Tests the code and deploys if successful
3. **Server updates** - Your GoDaddy server automatically pulls changes

## Manual Deployment

You can also run the deployment script manually:

```bash
cd /home/your-username/public_html/your-project-name
chmod +x deploy.sh
./deploy.sh
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**

    ```bash
    chmod -R 775 storage bootstrap/cache
    ```

2. **Composer not found**

    ```bash
    # Use full path or install composer locally
    /usr/local/bin/composer install
    ```

3. **Database connection errors**

    - Verify database credentials in `.env`
    - Ensure database exists in GoDaddy panel

4. **Storage symlink issues**
    ```bash
    php artisan storage:link
    ```

### Logs

Check Laravel logs:

```bash
tail -f storage/logs/laravel.log
```

## Security Notes

1. **Never commit `.env` files** to your repository
2. **Use strong passwords** for database and SSH
3. **Enable SSL/HTTPS** on your domain
4. **Keep dependencies updated** regularly
5. **Use environment-specific configurations**

## API Endpoints

After deployment, your API will be available at:

-   `POST /api/register` - User registration
-   `POST /api/login` - User login
-   `GET /api/user` - Get authenticated user
-   `POST /api/profile/update` - Update user profile
-   `DELETE /api/profile/image` - Delete profile image
-   `POST /api/logout` - User logout

## Support

If you encounter issues:

1. Check the GitHub Actions logs
2. Review server error logs
3. Verify file permissions
4. Confirm database connectivity

Happy deploying! 🚀
