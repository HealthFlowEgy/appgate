# Frontend Deployment Guide

This guide provides instructions for deploying the AppsGate Admin Panel to a production server.

## Requirements

- Ubuntu 22.04 server
- Nginx
- Node.js >= 18.x
- NPM >= 9.x

## Server Setup

### 1. Install Nginx and Node.js

```bash
sudo apt update
sudo apt install -y nginx

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 2. Configure Nginx

Create a new Nginx configuration file:

```bash
sudo nano /etc/nginx/sites-available/appsgate-admin
```

Paste the following configuration (and update `server_name`):

```nginx
server {
    listen 80;
    server_name admin.your-domain.com;
    root /var/www/appsgate-admin;

    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

Enable the site:

```bash
sudo ln -s /etc/nginx/sites-available/appsgate-admin /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 3. Create Deployment Directory

```bash
sudo mkdir -p /var/www/appsgate-admin
sudo chown -R $USER:$USER /var/www/appsgate-admin
```

## Manual Deployment

1.  **Build the application locally:**
    ```bash
    npm run build:prod
    ```

2.  **Copy files to server:**
    ```bash
    scp -r dist/* your_user@your_server:/var/www/appsgate-admin/
    ```

3.  **Set permissions:**
    ```bash
    sudo chown -R www-data:www-data /var/www/appsgate-admin
    sudo chmod -R 755 /var/www/appsgate-admin
    ```

## Automated Deployment (CI/CD)

This project includes a GitHub Actions workflow for automated deployment to production.

### Setup

1.  **Add Secrets to GitHub Repository:**
    -   `PRODUCTION_HOST`: Your server IP address
    -   `PRODUCTION_USERNAME`: Your SSH username
    -   `PRODUCTION_SSH_KEY`: Your private SSH key
    -   `FRONTEND_PRODUCTION_URL`: Your application URL (e.g., `https://admin.your-domain.com`)
    -   `SLACK_WEBHOOK`: Your Slack webhook URL for notifications

2.  **Push to `main` branch:**
    -   The `deploy-frontend-production.yml` workflow will automatically trigger on push to the `main` branch.

### Workflow Details

-   **Builds the application:** Installs dependencies and runs `npm run build:prod`.
-   **Copies files to server:** Uses `appleboy/scp-action` to copy the `dist/` directory to `/var/www/appsgate-admin`.
-   **Restarts Nginx:** Reloads Nginx to serve the new files.
-   **Health Check:** Pings the `/health` endpoint to ensure the deployment was successful.
-   **Slack Notification:** Sends a notification to Slack with the deployment status.

## Rollback Plan

### Manual Rollback

1.  **Revert to previous build:**
    -   If you have a backup of the previous `dist/` directory, you can restore it.

2.  **Rebuild from previous commit:**
    -   Check out the previous commit locally, rebuild, and re-deploy.

### Automated Rollback

-   The CI/CD pipeline does not currently have an automated rollback feature. This can be added using GitHub Actions to store previous build artifacts and revert if the health check fails.

## Monitoring

-   **Nginx Logs:** Check `/var/log/nginx/access.log` and `/var/log/nginx/error.log` for server errors.
-   **Browser DevTools:** Use the browser's developer console to check for any frontend errors.

---

**Last Updated:** November 5, 2025
