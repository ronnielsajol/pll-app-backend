# GitHub Actions Deployment Setup Checklist

## ✅ Pre-Deployment Checklist

### 1. Repository Secrets Configuration

Go to your GitHub repository → Settings → Secrets and Variables → Actions

Add these repository secrets:

| Secret Name            | Description                        | Example Value                             |
| ---------------------- | ---------------------------------- | ----------------------------------------- |
| `GODADDY_HOST`         | Your GoDaddy server IP or hostname | `123.456.789.012` or `your-domain.com`    |
| `GODADDY_USERNAME`     | Your SSH username                  | `your-username`                           |
| `GODADDY_PASSWORD`     | Your SSH password                  | `your-secure-password`                    |
| `GODADDY_PORT`         | SSH port (usually 22)              | `22`                                      |
| `GODADDY_PROJECT_PATH` | Full path to your project          | `/home/username/public_html/project-name` |

### 2. GoDaddy Server Preparation

#### Enable SSH Access

1. Log into GoDaddy hosting control panel
2. Navigate to SSH Access settings
3. Enable SSH access
4. Note your SSH credentials

#### Install Required Tools

```bash
# Connect via SSH
ssh your-username@your-server-ip

# Check PHP version (should be 8.1+)
php -v

# Check if composer is available
composer --version

# If composer not available, install it
curl -sS https://getcomposer.org/installer | php
mv composer.phar ~/bin/composer
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Setup Project Directory

```bash
# Navigate to your hosting directory
cd ~/public_html

# Clone your repository
git clone https://github.com/ronnielsajol/pll-app-backend.git your-project-name

# Navigate to project
cd your-project-name

# Install dependencies
composer install --no-dev --optimize-autoloader

# Copy and configure environment
cp .env.production .env
nano .env  # Update database credentials and other settings

# Generate application key
php artisan key:generate

# Set permissions
chmod -R 775 storage
chmod -R 775 bootstrap/cache

# Run initial migration
php artisan migrate --force

# Create storage symlink
php artisan storage:link
```

### 3. Database Setup

#### Create Database in GoDaddy

1. Log into GoDaddy hosting control panel
2. Go to Databases → MySQL
3. Create new database
4. Create database user
5. Assign user to database with all privileges
6. Note the database details for your `.env` file

#### Update .env File

```env
DB_CONNECTION=mysql
DB_HOST=localhost
DB_PORT=3306
DB_DATABASE=your_database_name
DB_USERNAME=your_database_user
DB_PASSWORD=your_database_password
```

### 4. Domain Configuration

#### Option A: Main Domain

If you want the API to be your main site:

```bash
cd ~/public_html/your-project-name
mv public/* ../
mv public/.htaccess ../
```

Update `~/public_html/index.php`:

```php
<?php
require __DIR__.'/your-project-name/vendor/autoload.php';
$app = require_once __DIR__.'/your-project-name/bootstrap/app.php';
// ... rest of the file
```

#### Option B: Subdomain

1. Create subdomain in GoDaddy panel (e.g., api.yourdomain.com)
2. Point it to `~/public_html/your-project-name/public`

### 5. Test Deployment

#### Manual Test

```bash
# SSH into your server
ssh your-username@your-server-ip

# Navigate to project
cd ~/public_html/your-project-name

# Run deployment script
chmod +x deploy.sh
./deploy.sh
```

#### API Test

Test your API endpoints:

```bash
# Test registration
curl -X POST https://yourdomain.com/api/register \
  -H "Content-Type: application/json" \
  -d '{
    "first_name": "Test",
    "last_name": "User",
    "email": "test@example.com",
    "contact_number": "1234567890",
    "dob": "1990-01-01",
    "password": "password123",
    "password_confirmation": "password123"
  }'

# Test login
curl -X POST https://yourdomain.com/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

## 🚀 Deployment Process

Once everything is set up:

1. **Push to main branch** triggers automatic deployment
2. **GitHub Action runs tests** and deploys if successful
3. **Monitor deployment** in GitHub Actions tab
4. **Check your site** to confirm deployment

## 🔧 Manual Deployment

You can also trigger deployment manually:

1. Go to GitHub repository
2. Click "Actions" tab
3. Select "Deploy to GoDaddy" workflow
4. Click "Run workflow"

## 📋 Troubleshooting

### Common Issues

1. **SSH Connection Failed**

    - Verify SSH is enabled in GoDaddy
    - Check SSH credentials
    - Ensure correct port (usually 22)

2. **Permission Denied**

    ```bash
    chmod -R 775 storage bootstrap/cache
    ```

3. **Composer Command Not Found**

    ```bash
    # Use full path or install composer
    /usr/local/bin/composer install
    # or
    php /home/username/composer.phar install
    ```

4. **Database Connection Error**

    - Verify database exists in GoDaddy panel
    - Check database credentials in `.env`
    - Ensure database user has proper privileges

5. **Storage Symlink Issues**
    ```bash
    rm public/storage
    php artisan storage:link
    ```

### Log Files to Check

-   `storage/logs/laravel.log` - Application logs
-   GitHub Actions logs - Deployment logs
-   GoDaddy error logs - Server errors

## 🎉 Success!

Your Laravel API should now be:

-   ✅ Automatically deployed on every push to main
-   ✅ Running on your GoDaddy server
-   ✅ Accessible via your domain
-   ✅ Ready for production use

## API Endpoints

Your deployed API endpoints:

-   `POST /api/register` - User registration with profile image
-   `POST /api/login` - User authentication
-   `GET /api/user` - Get authenticated user data
-   `POST /api/profile/update` - Update user profile
-   `DELETE /api/profile/image` - Delete profile image
-   `POST /api/logout` - User logout

Happy coding! 🚀
