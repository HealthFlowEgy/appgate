# AppsGate API Documentation

**Base URL:** `https://your-domain.com/api`  
**Version:** 1.0.0  
**Authentication:** Bearer Token (OAuth2)

---

## Authentication

### Admin Login

**Endpoint:** `POST /api/admin/login`

**Request Body:**
```json
{
  "email": "admin@example.com",
  "password": "password"
}
```

**Response:**
```json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "token_type": "Bearer",
  "expires_in": 31536000,
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@example.com"
  }
}
```

### User Registration

**Endpoint:** `POST /api/register`

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password",
  "password_confirmation": "password",
  "phone": "+1234567890"
}
```

### User Login

**Endpoint:** `POST /api/login`

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "password"
}
```

---

## Admin API

All admin endpoints require authentication with `Authorization: Bearer {token}` header.

### Users Management

#### List Users

**Endpoint:** `GET /api/admin/users`

**Query Parameters:**
- `page` (int): Page number
- `per_page` (int): Items per page (default: 15)
- `search` (string): Search by name or email
- `role` (string): Filter by role

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "+1234567890",
      "created_at": "2025-01-01T00:00:00.000000Z"
    }
  ],
  "meta": {
    "current_page": 1,
    "total": 100,
    "per_page": 15
  }
}
```

#### Get User

**Endpoint:** `GET /api/admin/users/{id}`

#### Create User

**Endpoint:** `POST /api/admin/users`

**Request Body:**
```json
{
  "name": "Jane Doe",
  "email": "jane@example.com",
  "password": "password",
  "phone": "+1234567890",
  "role": "user"
}
```

#### Update User

**Endpoint:** `PUT /api/admin/users/{id}`

#### Delete User

**Endpoint:** `DELETE /api/admin/users/{id}`

### Dashboard Analytics

#### User Analytics

**Endpoint:** `GET /api/admin/dashboard/user-analytics`

**Response:**
```json
{
  "total_users": 1000,
  "active_users": 850,
  "new_users_this_month": 50,
  "user_growth": [
    {"month": "Jan", "count": 100},
    {"month": "Feb", "count": 150}
  ]
}
```

#### Transaction Analytics

**Endpoint:** `GET /api/admin/dashboard/transaction-analytics`

**Response:**
```json
{
  "total_revenue": 50000,
  "total_transactions": 500,
  "pending_transactions": 10,
  "revenue_by_month": [
    {"month": "Jan", "amount": 5000},
    {"month": "Feb", "amount": 7500}
  ]
}
```

### Gate Management (Gateapp)

#### Projects

**Endpoint:** `GET /api/admin/gateapp/projects`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Sunrise Apartments",
      "address": "123 Main St, City",
      "latitude": "40.7128",
      "longitude": "-74.0060",
      "city_id": 1,
      "created_at": "2025-01-01T00:00:00.000000Z"
    }
  ]
}
```

**Create Project:** `POST /api/admin/gateapp/projects`

**Request Body:**
```json
{
  "title": "New Project",
  "address": "456 Oak Ave",
  "latitude": "40.7128",
  "longitude": "-74.0060",
  "city_id": 1
}
```

#### Buildings

**Endpoint:** `GET /api/admin/gateapp/buildings`

**Create Building:** `POST /api/admin/gateapp/buildings`

**Request Body:**
```json
{
  "title": "Building A",
  "project_id": 1
}
```

#### Flats

**Endpoint:** `GET /api/admin/gateapp/flats`

**Create Flat:** `POST /api/admin/gateapp/flats`

**Request Body:**
```json
{
  "title": "Flat 101",
  "building_id": 1
}
```

#### Residents

**Endpoint:** `GET /api/admin/gateapp/residents`

**Create Resident:** `POST /api/admin/gateapp/residents`

**Request Body:**
```json
{
  "user_id": 5,
  "project_id": 1,
  "building_id": 1,
  "flat_id": 1,
  "meta": {
    "move_in_date": "2025-01-01",
    "is_owner": true
  }
}
```

#### Visitor Logs

**Endpoint:** `GET /api/admin/gateapp/visitorlogs`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "visitor_name": "John Smith",
      "visitor_phone": "+1234567890",
      "purpose": "Delivery",
      "check_in": "2025-11-05T10:00:00.000000Z",
      "check_out": "2025-11-05T10:30:00.000000Z",
      "resident_id": 1,
      "guard_id": 1
    }
  ]
}
```

#### Announcements

**Endpoint:** `GET /api/admin/gateapp/announcements`

**Create Announcement:** `POST /api/admin/gateapp/announcements`

**Request Body:**
```json
{
  "title": "Community Meeting",
  "description": "Monthly community meeting on Saturday",
  "project_id": 1,
  "meta": {
    "date": "2025-11-10",
    "time": "18:00"
  }
}
```

#### Complaints

**Endpoint:** `GET /api/admin/gateapp/complaints`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Water Leakage",
      "description": "Water leaking from ceiling",
      "status": "pending",
      "resident_id": 1,
      "created_at": "2025-11-05T10:00:00.000000Z"
    }
  ]
}
```

#### Amenities

**Endpoint:** `GET /api/admin/gateapp/amenities`

**Create Amenity:** `POST /api/admin/gateapp/amenities`

**Request Body:**
```json
{
  "title": "Swimming Pool",
  "description": "Community swimming pool",
  "project_id": 1,
  "meta": {
    "capacity": 50,
    "booking_required": true
  }
}
```

#### Payment Requests

**Endpoint:** `GET /api/admin/gateapp/paymentrequests`

**Create Payment Request:** `POST /api/admin/gateapp/paymentrequests`

**Request Body:**
```json
{
  "title": "Monthly Maintenance",
  "amount": 100,
  "resident_id": 1,
  "due_date": "2025-11-30"
}
```

### Provider Management

#### Provider Profiles

**Endpoint:** `GET /api/admin/provider/providerprofiles`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "ABC Plumbing Services",
      "details": "Professional plumbing services",
      "user_id": 10,
      "fee": 50,
      "is_verified": 1,
      "categories": [
        {"id": 1, "name": "Plumbing"}
      ]
    }
  ]
}
```

#### Appointments

**Endpoint:** `GET /api/admin/provider/appointments`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "appointee_id": 1,
      "appointer_id": 5,
      "scheduled_at": "2025-11-10T14:00:00.000000Z",
      "status": "confirmed",
      "notes": "Fix kitchen sink"
    }
  ]
}
```

### Payment Methods

**Endpoint:** `GET /api/admin/paymentmethods`

**Create Payment Method:** `POST /api/admin/paymentmethods`

**Request Body:**
```json
{
  "name": "Stripe",
  "slug": "stripe",
  "is_active": true,
  "meta": {
    "public_key": "pk_test_...",
    "secret_key": "sk_test_..."
  }
}
```

### Settings

**Endpoint:** `GET /api/admin/settings`

**Update Settings:** `POST /api/admin/settings`

**Request Body:**
```json
{
  "app_name": "AppsGate",
  "currency": "USD",
  "timezone": "UTC",
  "meta": {
    "maintenance_mode": false
  }
}
```

---

## Mobile/Web API

### User Profile

#### Get Current User

**Endpoint:** `GET /api/user`

**Headers:**
```
Authorization: Bearer {token}
```

**Response:**
```json
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com",
  "phone": "+1234567890",
  "avatar": "https://...",
  "created_at": "2025-01-01T00:00:00.000000Z"
}
```

#### Update Profile

**Endpoint:** `PUT /api/user`

**Request Body:**
```json
{
  "name": "John Updated",
  "phone": "+9876543210"
}
```

### Gateapp (Resident Features)

#### My Profile

**Endpoint:** `GET /api/gateapp/residents/myprofile`

**Response:**
```json
{
  "id": 1,
  "user_id": 5,
  "project": {
    "id": 1,
    "title": "Sunrise Apartments"
  },
  "building": {
    "id": 1,
    "title": "Building A"
  },
  "flat": {
    "id": 1,
    "title": "Flat 101"
  }
}
```

#### Visitor Logs

**Endpoint:** `GET /api/gateapp/visitorlogs`

**Create Visitor Log:** `POST /api/gateapp/visitorlogs`

**Request Body:**
```json
{
  "visitor_name": "Jane Smith",
  "visitor_phone": "+1234567890",
  "purpose": "Personal Visit",
  "expected_time": "2025-11-05T15:00:00.000000Z"
}
```

### Provider Features

#### My Provider Profile

**Endpoint:** `GET /api/provider/profile`

**Update Provider Profile:** `PUT /api/provider/profile`

**Request Body:**
```json
{
  "name": "Updated Service Name",
  "details": "Updated description",
  "fee": 75,
  "categories": [1, 2, 3]
}
```

#### My Appointments

**Endpoint:** `GET /api/provider/appointments`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "resident": {
        "id": 5,
        "name": "John Doe"
      },
      "scheduled_at": "2025-11-10T14:00:00.000000Z",
      "status": "confirmed"
    }
  ]
}
```

### Wallet

#### Check Balance

**Endpoint:** `GET /api/user/wallet/balance`

**Response:**
```json
{
  "balance": 500.00,
  "currency": "USD"
}
```

#### Deposit

**Endpoint:** `POST /api/user/wallet/deposit`

**Request Body:**
```json
{
  "amount": 100,
  "payment_method": "stripe"
}
```

#### Transactions

**Endpoint:** `GET /api/user/wallet/transactions`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "type": "deposit",
      "amount": 100,
      "description": "Wallet deposit",
      "created_at": "2025-11-05T10:00:00.000000Z"
    }
  ]
}
```

### Payments

#### Available Payment Methods

**Endpoint:** `GET /api/payment/methods`

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "name": "Stripe",
      "slug": "stripe",
      "is_active": true
    },
    {
      "id": 2,
      "name": "Paystack",
      "slug": "paystack",
      "is_active": true
    }
  ]
}
```

#### Make Payment (Stripe)

**Endpoint:** `GET /api/payment/stripe/{payment_id}`

**Response:**
```json
{
  "checkout_url": "https://checkout.stripe.com/...",
  "session_id": "cs_test_..."
}
```

---

## Error Responses

All API endpoints return standard error responses:

### 400 Bad Request
```json
{
  "message": "Validation failed",
  "errors": {
    "email": ["The email field is required."]
  }
}
```

### 401 Unauthorized
```json
{
  "message": "Unauthenticated."
}
```

### 403 Forbidden
```json
{
  "message": "This action is unauthorized."
}
```

### 404 Not Found
```json
{
  "message": "Resource not found."
}
```

### 500 Internal Server Error
```json
{
  "message": "Server error occurred."
}
```

---

## Rate Limiting

API requests are rate-limited to **60 requests per minute** per user.

**Headers:**
```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 59
X-RateLimit-Reset: 1699200000
```

---

## Pagination

List endpoints support pagination with the following parameters:

- `page` (int): Page number (default: 1)
- `per_page` (int): Items per page (default: 15, max: 100)

**Response Meta:**
```json
{
  "data": [...],
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 10,
    "per_page": 15,
    "to": 15,
    "total": 150
  }
}
```

---

## Localization

Include the `X-Localization` header to receive responses in different languages:

```
X-Localization: en
X-Localization: es
X-Localization: fr
```

---

**Last Updated:** November 5, 2025
