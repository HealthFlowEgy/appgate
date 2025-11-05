# AppsGate Backend API

A comprehensive Laravel-based backend API for the AppsGate gate management and community platform.

## Features

- **Gate Management:** Visitor logs, guard management, announcements, complaints
- **Community Platform:** Resident directory, social features, user interactions
- **Service Marketplace:** Provider profiles, appointments, bookings
- **Payment Processing:** Multiple payment gateways (Stripe, Paystack, Razorpay, etc.)
- **Wallet System:** Internal wallet with transactions and payouts
- **Content Platform:** Media management, playlists, episodes, comments
- **Subscription Plans:** Flexible subscription system for providers
- **Multi-language Support:** Localization and translations

## Tech Stack

- **Framework:** Laravel 11.0
- **PHP:** 8.2.0
- **Database:** MySQL 8.0
- **Cache/Queue:** Redis
- **Testing:** Pest PHP 3.7
- **Authentication:** Laravel Passport (OAuth2)

## Requirements

- PHP >= 8.2
- Composer
- MySQL >= 8.0
- Redis (optional, but recommended for production)
- Node.js & NPM (for frontend assets)

## Installation

### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/HealthFlowEgy/appgate.git
   cd appgate/Backend-API
   ```

2. **Install dependencies:**
   ```bash
   composer install
   npm install
   ```

3. **Set up environment:**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```

4. **Configure database in `.env`:**
   ```env
   DB_CONNECTION=mysql
   DB_HOST=127.0.0.1
   DB_PORT=3306
   DB_DATABASE=gateapp
   DB_USERNAME=root
   DB_PASSWORD=your_password
   ```

5. **Run migrations:**
   ```bash
   php artisan migrate --seed
   ```

6. **Install Passport:**
   ```bash
   php artisan passport:install
   ```

7. **Start development server:**
   ```bash
   php artisan serve
   ```

The API will be available at `http://localhost:8000`

### Docker Deployment

1. **Build and run with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

2. **Run migrations inside container:**
   ```bash
   docker-compose exec app php artisan migrate --seed
   docker-compose exec app php artisan passport:install
   ```

The API will be available at `http://localhost:8000`

## Configuration

### Environment Variables

Copy `.env.production.example` for production deployment and configure:

- **App Settings:** `APP_ENV`, `APP_DEBUG`, `APP_URL`
- **Database:** `DB_*` variables
- **Redis:** `REDIS_*` variables
- **Mail:** `MAIL_*` variables
- **Payment Gateways:** `STRIPE_*`, `PAYSTACK_*`, etc.
- **Firebase:** `FIREBASE_*` variables
- **OneSignal:** `ONESIGNAL_*` variables

### GitLab Authentication

For VTLabs packages, create `auth.json`:

```json
{
    "gitlab-oauth": {
        "gitlab.com": "YOUR_GITLAB_TOKEN"
    }
}
```

## API Documentation

### Health Check

```bash
GET /health
GET /health/detailed
```

### Authentication

```bash
POST /api/admin/login
POST /api/register
POST /api/login
```

### Admin Endpoints

All admin endpoints are prefixed with `/api/admin` and require authentication.

- **Users:** `/api/admin/users`
- **Settings:** `/api/admin/settings`
- **Dashboard:** `/api/admin/dashboard/*`
- **Gate Management:** `/api/admin/gateapp/*`
- **Providers:** `/api/admin/provider/*`
- **Media:** `/api/admin/media`
- **Payments:** `/api/admin/paymentmethods`

### Mobile/Web API Endpoints

- **User Profile:** `/api/user`
- **Gateapp:** `/api/gateapp/*`
- **Provider:** `/api/provider/*`
- **Media:** `/api/media/*`
- **Payments:** `/api/payment/*`
- **Wallet:** `/api/user/wallet/*`

## Testing

Run tests with Pest:

```bash
# Run all tests
./vendor/bin/pest

# Run with coverage
./vendor/bin/pest --coverage

# Run specific test
./vendor/bin/pest tests/Feature/AdminLoginTest.php
```

## Queue Workers

For production, run queue workers:

```bash
php artisan queue:work --tries=3 --timeout=90
```

Or use Supervisor (see `docker/supervisord.conf` for configuration).

## Scheduled Tasks

Add to crontab for scheduled tasks:

```bash
* * * * * cd /path-to-your-project && php artisan schedule:run >> /dev/null 2>&1
```

## Deployment

### Manual Deployment

1. Pull latest code
2. Install dependencies: `composer install --no-dev --optimize-autoloader`
3. Run migrations: `php artisan migrate --force`
4. Clear and cache config: `php artisan config:cache`
5. Cache routes: `php artisan route:cache`
6. Restart queue workers: `php artisan queue:restart`

### Docker Deployment

See `UPGRADE_GUIDE.md` for detailed deployment instructions.

## Security

- **Never commit `.env` files**
- **Rotate API keys regularly**
- **Use HTTPS in production**
- **Enable rate limiting**
- **Keep dependencies updated**
- **Disable Telescope in production** (set `TELESCOPE_ENABLED=false`)

## Troubleshooting

### Common Issues

**Issue:** Composer install fails for VTLabs packages

**Solution:** Ensure `auth.json` is configured with GitLab token.

---

**Issue:** Queue jobs not processing

**Solution:** Check queue worker is running and Redis is connected.

---

**Issue:** Migrations fail

**Solution:** Check database credentials and ensure MySQL is running.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write tests
5. Submit a pull request

## License

Proprietary - All rights reserved

## Support

For issues and questions, please open an issue on GitHub or contact the development team.

---

**Last Updated:** November 5, 2025
