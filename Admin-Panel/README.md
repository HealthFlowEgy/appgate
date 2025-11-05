# AppsGate Admin Panel

A comprehensive Angular-based admin panel for the AppsGate gate management and community platform.

## Features

- **Dashboard Analytics:** Real-time statistics and charts for users, transactions, and system metrics
- **User Management:** Manage users, residents, and providers
- **Gate Management:** Projects, buildings, flats, visitor logs, announcements, complaints
- **Provider Management:** Service provider profiles, appointments, and bookings
- **Payment Management:** Payment methods, transactions, and wallet management
- **Media Management:** Content, authors, playlists, and episodes
- **Settings:** Application configuration and system settings

## Tech Stack

- **Framework:** Angular 17.1.0
- **UI Library:** Nebular 13.0.0
- **Charts:** ngx-charts, ng2-charts, echarts
- **State Management:** RxJS 7.8.1
- **HTTP Client:** Angular HttpClient
- **Build Tool:** Angular CLI 17.1.0

## Requirements

- Node.js >= 18.x (use `nvm use 20` for Node 20)
- NPM >= 9.x
- Angular CLI 17.1.0

## Installation

### Local Development

1. **Clone the repository:**
   ```bash
   git clone https://github.com/HealthFlowEgy/appgate.git
   cd appgate/Admin-Panel
   ```

2. **Install dependencies:**
   ```bash
   npm install --legacy-peer-deps
   ```

3. **Configure API endpoint:**
   
   Edit `src/app/appConfig.json` to set your backend API URL:
   ```json
   {
     "apiUrl": "http://localhost:8000"
   }
   ```

4. **Start development server:**
   ```bash
   npm start
   ```

   The application will be available at `http://localhost:4200`

### Docker Deployment

1. **Build and run with Docker Compose:**
   ```bash
   docker-compose up -d
   ```

   The application will be available at `http://localhost:4200`

## Configuration

### Environment Files

- **Development:** `src/environments/environment.ts`
- **Production:** `src/environments/environment.prod.ts`

Update the following in production environment:

```typescript
export const environment = {
  production: true,
  apiUrl: 'https://api.your-domain.com/api',
  apiBaseUrl: 'https://api.your-domain.com',
  // ... other configuration
};
```

### API Configuration

The application uses `appConfig.json` for runtime API configuration. This file is loaded at application startup and can be modified without rebuilding the application.

**Location:** `src/app/appConfig.json`

```json
{
  "apiUrl": "https://api.your-domain.com"
}
```

## Building for Production

### Standard Build

```bash
npm run build:prod
```

This will create an optimized production build in the `dist/` directory.

### Docker Build

```bash
docker build -t appsgate-admin .
docker run -p 80:80 appsgate-admin
```

## Testing

### Unit Tests

```bash
npm test
```

### Test Coverage

```bash
npm run test:coverage
```

### End-to-End Tests

```bash
npm run e2e
```

## Code Quality

### Linting

```bash
npm run lint
```

### Auto-fix Linting Issues

```bash
npm run lint:fix
```

### Style Linting

```bash
npm run lint:styles
```

## Project Structure

```
Admin-Panel/
├── src/
│   ├── app/
│   │   ├── @core/           # Core services and utilities
│   │   ├── @theme/          # Theme configuration and components
│   │   ├── pages/           # Application pages/modules
│   │   │   ├── dashboard/   # Dashboard module
│   │   │   ├── users/       # User management
│   │   │   ├── gateapp/     # Gate management
│   │   │   ├── provider/    # Provider management
│   │   │   └── ...
│   │   ├── appConfig.json   # Runtime API configuration
│   │   └── app.module.ts    # Root module
│   ├── assets/              # Static assets
│   ├── environments/        # Environment configurations
│   └── index.html           # Entry HTML
├── Dockerfile               # Docker configuration
├── nginx.conf               # Nginx configuration
└── package.json             # NPM dependencies
```

## Key Modules

### Dashboard
- User analytics
- Transaction analytics
- System metrics
- Real-time charts

### User Management
- List, create, update, delete users
- Role and permission management
- User activity logs

### Gate Management
- Projects, buildings, and flats
- Resident management
- Visitor logs
- Announcements
- Complaints
- Amenities
- Payment requests

### Provider Management
- Provider profiles
- Appointments
- Service categories
- Ratings and reviews

### Payment Management
- Payment methods configuration
- Transaction history
- Wallet management

## Known Issues

### Nebular Compatibility

The current version of Nebular (13.0.0) has compatibility issues with Angular 17. This may cause some UI components to not work as expected. See `ANGULAR_UPGRADE_STRATEGY.md` for migration plan.

### Hardcoded API URL

The API URL is currently hardcoded in `appConfig.json`. For production deployments, this should be configured via environment variables or a build-time configuration.

## Deployment

See `DEPLOYMENT_GUIDE.md` for detailed deployment instructions.

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
