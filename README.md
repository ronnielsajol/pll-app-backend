# PLL App Backend API

[![Deploy to GoDaddy](https://github.com/ronnielsajol/pll-app-backend/actions/workflows/deploy.yml/badge.svg)](https://github.com/ronnielsajol/pll-app-backend/actions/workflows/deploy.yml)

A comprehensive Laravel API backend for the PLL application featuring user authentication, profile management, and image upload capabilities.

## 🚀 Features

-   **User Authentication** - Registration, login, logout with Laravel Sanctum
-   **Profile Management** - Complete user profile with image upload support
-   **Image Handling** - Profile picture upload, update, and deletion
-   **RESTful API** - Clean and well-documented API endpoints
-   **Auto Deployment** - GitHub Actions CI/CD pipeline to GoDaddy hosting
-   **Database Migrations** - Structured database schema with migrations
-   **Form Validation** - Comprehensive request validation
-   **File Storage** - Secure file storage with symlink support

## 📋 User Model Fields

-   First Name
-   Last Name
-   Email Address
-   Contact Number
-   Date of Birth
-   Password (encrypted)
-   Role (admin, user, moderator)
-   Profile Image (optional)

## 🛠️ Tech Stack

-   **Framework**: Laravel 11
-   **Authentication**: Laravel Sanctum
-   **Database**: MySQL
-   **File Storage**: Local storage with symlink
-   **Testing**: PHPUnit/Pest
-   **Deployment**: GitHub Actions + GoDaddy Hosting

## 📡 API Endpoints

### Public Endpoints

-   `POST /api/register` - User registration with optional profile image
-   `POST /api/login` - User authentication

### Protected Endpoints (Requires Bearer Token)

-   `GET /api/user` - Get authenticated user information
-   `POST /api/profile/update` - Update user profile with optional image
-   `DELETE /api/profile/image` - Delete user profile image
-   `POST /api/logout` - User logout

## 🔧 Installation & Setup

### Local Development

1. **Clone the repository**

    ```bash
    git clone https://github.com/ronnielsajol/pll-app-backend.git
    cd pll-app-backend
    ```

2. **Install dependencies**

    ```bash
    composer install
    ```

3. **Environment setup**

    ```bash
    cp .env.example .env
    php artisan key:generate
    ```

4. **Database setup**

    ```bash
    # Update .env with your database credentials
    php artisan migrate
    ```

5. **Storage setup**

    ```bash
    php artisan storage:link
    ```

6. **Start development server**
    ```bash
    php artisan serve
    ```

### Production Deployment

See [DEPLOYMENT.md](DEPLOYMENT.md) for complete GoDaddy deployment instructions and [SETUP-CHECKLIST.md](SETUP-CHECKLIST.md) for the setup checklist.

## 📱 API Usage Examples

### Register User with Profile Image

```bash
curl -X POST http://localhost:8000/api/register \
  -F "first_name=John" \
  -F "last_name=Doe" \
  -F "email=john@example.com" \
  -F "contact_number=+1234567890" \
  -F "dob=1990-01-01" \
  -F "password=password123" \
  -F "password_confirmation=password123" \
  -F "profile_image=@/path/to/image.jpg"
```

### Login

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "john@example.com",
    "password": "password123"
  }'
```

### Get User Profile (with token)

```bash
curl -X GET http://localhost:8000/api/user \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

## 🧪 Testinggg

Run the test suite:

```bash
php artisan test
```

## 🚀 Deployment Status

This project includes automated deployment to GoDaddy hosting via GitHub Actions. Every push to the `main` branch triggers:

1. **Automated testing** - Runs full test suite
2. **Deployment** - Deploys to production server if tests pass
3. **Cache optimization** - Optimizes application performance
4. **Database migrations** - Runs any pending migrations

### 🔧 Deployment Setup testt

**If you're seeing SSH authentication errors:**

-   See [SSH-TROUBLESHOOTING.md](SSH-TROUBLESHOOTING.md) for detailed solutions
-   Use SSH key authentication (recommended) instead of passwords
-   Verify your GoDaddy hosting includes SSH access

**Required GitHub Secrets:**

-   `GODADDY_HOST` - Your server IP or domain
-   `GODADDY_USERNAME` - SSH username
-   `GODADDY_SSH_KEY` or `GODADDY_PASSWORD` - Authentication
-   `GODADDY_PORT` - SSH port (usually 22)
-   `GODADDY_PROJECT_PATH` - Full project path on server

## 📄 Documentation

-   [DEPLOYMENT.md](DEPLOYMENT.md) - Complete deployment guide
-   [SETUP-CHECKLIST.md](SETUP-CHECKLIST.md) - Quick setup checklist

## 🔐 Security

-   Password hashing with bcrypt
-   API token authentication
-   File upload validation
-   Input sanitization and validation
-   HTTPS support ready

## 📝 Change Log

### v1.0.0 (October 2025)

-   ✅ Initial release with user authentication
-   ✅ Profile image upload functionality
-   ✅ GitHub Actions deployment pipeline
-   ✅ Complete API documentation
-   ✅ Production-ready configuration

---

<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>
