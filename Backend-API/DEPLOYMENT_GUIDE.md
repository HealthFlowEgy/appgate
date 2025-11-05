# Backend Deployment Guide

This guide provides instructions for deploying the AppsGate backend API to a production server.

## Requirements

- Ubuntu 22.04 server
- Nginx
- PHP 8.2
- MySQL 8.0
- Redis
- Composer
- Git

## Server Setup

### 1. Install Nginx, PHP, and MySQL

```bash
sudo apt update
sudo apt install -y nginx php8.2-fpm php8.2-mysql php8.2-mbstring php8.2-xml php8.2-zip php8.2-curl php8.2-gd php8.2-redis mysql-server redis-server
```

### 2. Secure MySQL

```bash
sudo mysql_secure_installation
```

### 3. Create Database

```bash
sudo mysql -u root -p

CREATE DATABASE gateapp;
CREATE USER 'gateapp_user'@'localhost' IDENTIFIED BY 'your_strong_password';
GRANT ALL PRIVILEGES ON gateapp.* TO 'gateapp_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 4. Configure Nginx

Create a new Nginx configuration file:

```bash
sudo nano /etc/nginx/sites-available/appsgate
```

Paste the following configuration (and update `server_name`):

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/appsgate/Backend-API/public;

    index index.php index.html index.htm;

    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
    }

    location ~ /\.ht {
        deny all;
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/appsgate /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Install Composer

```bash
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

## Deployment

### 1. Clone Repository

```bash
sudo mkdir -p /var/www
sudo chown -R $USER:$USER /var/www

cd /var/www
git clone https://github.com/HealthFlowEgy/appgate.git
cd appgate/Backend-API
```

### 2. Install Dependencies

```bash
composer install --no-dev --optimize-autoloader
```

### 3. Configure Environment

```bash
cp .env.production.example .env
nano .env
```

Update the following variables in `.env`:

- `APP_URL`
- `DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`
- `MAIL_*` variables
- All payment gateway, Firebase, and OneSignal keys

Generate application key:

```bash
php artisan key:generate
```

### 4. Set Permissions

```bash
sudo chown -R www-data:www-data /var/www/appsgate/Backend-API/storage /var/www/appsgate/Backend-API/bootstrap/cache
sudo chmod -R 775 /var/www/appsgate/Backend-API/storage /var/www/appsgate/Backend-API/bootstrap/cache
```

### 5. Run Migrations

```bash
php artisan migrate --force
```

### 6. Cache Configuration

```bash
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### 7. Set Up Queue Workers

Create a Supervisor configuration file:

```bash
sudo nano /etc/supervisor/conf.d/appsgate-worker.conf
```

Paste the following:

```ini
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/appsgate/Backend-API/artisan queue:work --sleep=3 --tries=3 --max-time=3600
autostart=true
autorestart=true
user=www-data
numprocs=2
redirect_stderr=true
stdout_logfile=/var/www/appsgate/Backend-API/storage/logs/worker.log
stopwaitsecs=3600
```

Start the workers:

```bash
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start laravel-worker:*
```

### 8. Set Up Scheduler

Add to crontab:

```bash
sudo crontab -e
```

Add this line:

```
* * * * * cd /var/www/appsgate/Backend-API && php artisan schedule:run >> /dev/null 2>&1
```

## Automated Deployment (CI/CD)

This project includes a GitHub Actions workflow for automated deployment to production.

### Setup

1.  **Add Secrets to GitHub Repository:**
    -   `PRODUCTION_HOST`: Your server IP address
    -   `PRODUCTION_USERNAME`: Your SSH username
    -   `PRODUCTION_SSH_KEY`: Your private SSH key
    -   `PRODUCTION_URL`: Your application URL (e.g., `https://your-domain.com`)
    -   `SLACK_WEBHOOK`: Your Slack webhook URL for notifications

2.  **Push to `main` branch:**
    -   The `deploy-production.yml` workflow will automatically trigger on push to the `main` branch.

### Workflow Details

-   **Connects via SSH:** Uses `appleboy/ssh-action` to connect to your server.
-   **Pulls latest code:** `git pull origin main`
-   **Installs dependencies:** `composer install --no-dev`
-   **Runs migrations:** `php artisan migrate --force`
-   **Caches config:** `php artisan config:cache`, `route:cache`, `view:cache`
-   **Restarts services:** `php artisan queue:restart`, `systemctl reload php8.2-fpm`, `systemctl reload nginx`
-   **Health Check:** Pings the `/health` endpoint to ensure the deployment was successful.
-   **Slack Notification:** Sends a notification to Slack with the deployment status.

## Rollback Plan

### Manual Rollback

1.  **Revert code:**
    ```bash
    cd /var/www/appsgate/Backend-API
    git checkout <previous_commit_hash>
    ```

2.  **Re-run deployment steps:**
    -   Install dependencies
    -   Run migrations (if needed)
    -   Clear caches
    -   Restart services

### Automated Rollback

-   The CI/CD pipeline does not currently have an automated rollback feature. This can be added using GitHub Actions to revert to the previous successful commit if the health check fails.

## Monitoring

-   **Logs:** Check `storage/logs/laravel.log` for application errors.
-   **Queue Workers:** Check `storage/logs/worker.log` for queue worker output.
-   **Scheduler:** Check `storage/logs/scheduler.log` for scheduled task output.
-   **Nginx Logs:** Check `/var/log/nginx/access.log` and `/var/log/nginx/error.log`.
-   **Telescope:** For local development, use Telescope dashboard at `/telescope`.

---

**Last Updated:** November 5, 2025
