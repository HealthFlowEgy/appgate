# Backend API Upgrade Guide

## Current Stack
- **Laravel:** 11.0 (Latest ✅)
- **PHP:** 8.2.0 (Current ✅)
- **Testing:** Pest PHP 3.7 (Latest ✅)

---

## ⚠️ Known Issues

### 1. Dev Dependencies in Production
The following packages use development branches:
```json
"vtlabs/core": "v3.x-dev",
"vtlabs/provider": "v3.x-dev",
"vtlabs/gateapp": "v2.x-dev",
"vtlabs/media": "v2.x-dev"
```

**Risk:** Dev branches can introduce breaking changes without notice.

**Recommendation:**
Contact VTLabs to request stable release tags, or fork and maintain your own stable versions.

---

## 🚀 Upgrade Steps

### Step 1: Backup Everything
```bash
# Backup database
mysqldump -u root -p gateapp > backup_$(date +%Y%m%d).sql

# Create git tag
git tag v1.0.0-pre-upgrade
git push --tags

# Backup files
tar -czf appgate_backup_$(date +%Y%m%d).tar.gz /path/to/appgate
```

### Step 2: Update Dependencies
```bash
cd Backend-API

# Update composer dependencies
composer update --no-dev

# Check for security vulnerabilities
composer audit

# If vulnerabilities found, update specific packages
composer update package/name
```

### Step 3: Run Database Migrations
```bash
# Test migrations on local/staging first
php artisan migrate --pretend

# Run migrations
php artisan migrate --force
```

### Step 4: Clear and Rebuild Caches
```bash
# Clear all caches
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# Rebuild caches (production only)
php artisan config:cache
php artisan route:cache
php artisan view:cache
```

### Step 5: Run Tests
```bash
# Run all tests
php artisan test

# Or use Pest directly
./vendor/bin/pest

# With coverage
./vendor/bin/pest --coverage
```

### Step 6: Optimize for Production
```bash
# Optimize autoloader
composer install --optimize-autoloader --no-dev

# Cache config
php artisan config:cache

# Cache routes
php artisan route:cache

# Cache views
php artisan view:cache
```

---

## 🔒 Security Hardening

### 1. Environment Configuration
Copy `.env.production.example` to `.env` and fill in production values:
```bash
cp .env.production.example .env
nano .env  # Edit with production credentials
```

### 2. Generate New Application Key
```bash
php artisan key:generate
```

### 3. Configure Session Security
Update `config/session.php`:
```php
'secure' => env('SESSION_SECURE_COOKIE', true),
'http_only' => true,
'same_site' => 'strict',
```

### 4. Enable HTTPS Enforcement
Add to `app/Providers/AppServiceProvider.php`:
```php
public function boot()
{
    if ($this->app->environment('production')) {
        \URL::forceScheme('https');
    }
}
```

### 5. Configure CORS
Update `config/cors.php`:
```php
'allowed_origins' => [env('FRONTEND_URL')],
'allowed_origins_patterns' => [],
'supports_credentials' => true,
```

### 6. Add Rate Limiting
Update `routes/api.php`:
```php
Route::middleware(['throttle:60,1'])->group(function () {
    // Your API routes here
});
```

---

## 📊 Performance Optimization

### 1. Enable OPcache
Add to `php.ini`:
```ini
opcache.enable=1
opcache.memory_consumption=256
opcache.max_accelerated_files=20000
opcache.validate_timestamps=0  ; Production only
```

### 2. Use Redis for Caching
```bash
# Install Redis
sudo apt-get install redis-server

# Update .env
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

### 3. Queue Heavy Operations
```php
// Instead of processing immediately
ProcessPayment::dispatch($payment);

// Or with delay
ProcessPayment::dispatch($payment)->delay(now()->addMinutes(5));
```

### 4. Database Query Optimization
```php
// Use eager loading to prevent N+1 queries
$users = User::with('profile', 'residency')->get();

// Cache expensive queries
$users = Cache::remember('all_users', 3600, function () {
    return User::all();
});
```

---

## 🧪 Testing Checklist

### Before Deployment
- [ ] All unit tests passing
- [ ] All feature tests passing
- [ ] Integration tests passing
- [ ] Database migrations tested
- [ ] API endpoints tested
- [ ] Payment flows tested (sandbox)
- [ ] Email sending tested
- [ ] Push notifications tested
- [ ] File uploads tested
- [ ] Authentication tested

### After Deployment
- [ ] Health check endpoint responding
- [ ] Database connection working
- [ ] Redis connection working
- [ ] Queue workers running
- [ ] Cron jobs scheduled
- [ ] SSL certificate valid
- [ ] API responses correct
- [ ] Error logging working
- [ ] Monitoring alerts configured

---

## 🚨 Rollback Plan

If something goes wrong:

```bash
# 1. Enable maintenance mode
php artisan down

# 2. Restore database backup
mysql -u root -p gateapp < backup_YYYYMMDD.sql

# 3. Revert code
git checkout v1.0.0-pre-upgrade

# 4. Restore dependencies
composer install

# 5. Clear caches
php artisan config:clear
php artisan cache:clear

# 6. Disable maintenance mode
php artisan up
```

---

## 📋 Deployment Checklist

### Pre-Deployment
- [ ] Code reviewed and approved
- [ ] All tests passing
- [ ] Database backup completed
- [ ] Rollback plan documented
- [ ] Monitoring configured
- [ ] Team notified

### Deployment
- [ ] Enable maintenance mode
- [ ] Pull latest code
- [ ] Update dependencies
- [ ] Run migrations
- [ ] Clear caches
- [ ] Restart services
- [ ] Disable maintenance mode

### Post-Deployment
- [ ] Smoke tests passed
- [ ] Monitoring shows no errors
- [ ] API endpoints responding
- [ ] Database queries optimized
- [ ] No memory leaks
- [ ] Response times acceptable

---

## 🔧 Troubleshooting

### Issue: Composer Install Fails
```bash
# Clear composer cache
composer clear-cache

# Update composer itself
composer self-update

# Try with verbose output
composer install -vvv
```

### Issue: Migrations Fail
```bash
# Check migration status
php artisan migrate:status

# Rollback last migration
php artisan migrate:rollback --step=1

# Fresh migration (WARNING: Deletes all data)
php artisan migrate:fresh
```

### Issue: Queue Not Processing
```bash
# Check queue status
php artisan queue:work --once

# Restart queue workers
php artisan queue:restart

# Check supervisor configuration
sudo supervisorctl status
```

### Issue: Cache Not Clearing
```bash
# Clear all caches
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear

# Clear Redis manually
redis-cli FLUSHALL
```

---

## 📞 Support

For issues with VTLabs packages:
- Check GitLab repositories
- Contact VTLabs support
- Review package documentation

For Laravel issues:
- Laravel Documentation: https://laravel.com/docs/11.x
- Laravel Forums: https://laracasts.com/discuss
- Stack Overflow: https://stackoverflow.com/questions/tagged/laravel

---

**Last Updated:** November 5, 2025
