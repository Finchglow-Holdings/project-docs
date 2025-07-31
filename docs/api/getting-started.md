# API Getting Started

Welcome to the TravelDen API documentation. This guide will help you get started with integrating our travel booking services.

## Base URL

```
https://api.travelden.com/v1
```

## Authentication

All API requests require authentication using Bearer tokens.

```http
Authorization: Bearer YOUR_API_TOKEN
```

### Getting an API Token

```mermaid
sequenceDiagram
    participant Client
    participant Auth API
    participant Token Store
    
    Client->>Auth API: POST /auth/login
    Note over Client,Auth API: email, password
    Auth API->>Token Store: Validate credentials
    Token Store-->>Auth API: User validated
    Auth API-->>Client: JWT Token + Refresh Token
    
    Note over Client: Store tokens securely
    
    Client->>Auth API: API Request with Bearer token
    Auth API->>Token Store: Validate token
    Token Store-->>Auth API: Token valid
    Auth API-->>Client: API Response
```

### Authentication Example

```bash
# Login to get token
curl -X POST https://api.travelden.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "your_password"
  }'

# Response
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...",
  "token_type": "bearer",
  "expires_in": 3600,
  "refresh_token": "def50200..."
}

# Use token in subsequent requests
curl -X GET https://api.travelden.com/v1/products \
  -H "Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9..."
```

## Rate Limiting

API requests are rate-limited to ensure fair usage:

| Plan | Requests per minute | Requests per hour |
|------|-------------------|------------------|
| Free | 60 | 1,000 |
| Basic | 300 | 10,000 |
| Premium | 1,000 | 50,000 |
| Enterprise | Custom | Custom |

Rate limit headers are included in all responses:

```http
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 59
X-RateLimit-Reset: 1640995200
```

## Request/Response Format

### Content Type
All requests should use `application/json` content type:

```http
Content-Type: application/json
```

### Standard Response Format

```json
{
  "success": true,
  "data": {
    // Response data here
  },
  "meta": {
    "pagination": {
      "current_page": 1,
      "per_page": 20,
      "total": 100,
      "last_page": 5
    }
  }
}
```

### Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The given data was invalid.",
    "details": {
      "email": ["The email field is required."],
      "password": ["The password field is required."]
    }
  }
}
```

## Common HTTP Status Codes

| Code | Meaning | Description |
|------|---------|-------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 400 | Bad Request | Invalid request data |
| 401 | Unauthorized | Authentication required |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 422 | Unprocessable Entity | Validation errors |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |

## API Workflow

```mermaid
graph TD
    A[Client Application] --> B[Authenticate]
    B --> C[Get API Token]
    C --> D[Search Products]
    D --> E[Create Booking]
    E --> F[Process Payment]
    F --> G[Confirm Booking]
    G --> H[Get Booking Details]
    
    B --> I[Handle Auth Errors]
    D --> J[Handle Search Errors]
    E --> K[Handle Booking Errors]
    F --> L[Handle Payment Errors]
```

## Quick Start Example

Here's a complete example of searching for flights and creating a booking:

### 1. Authenticate

```bash
curl -X POST https://api.travelden.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

### 2. Search Products

```bash
curl -X GET "https://api.travelden.com/v1/products/search?type=flight&origin=NYC&destination=LAX&departure_date=2024-03-15" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Create Booking

```bash
curl -X POST https://api.travelden.com/v1/bookings \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "product_id": "flight-123",
    "passengers": [
      {
        "first_name": "John",
        "last_name": "Doe",
        "date_of_birth": "1990-01-01",
        "passport_number": "A12345678"
      }
    ]
  }'
```

### 4. Process Payment

```bash
curl -X POST https://api.travelden.com/v1/payments \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "booking_id": "booking-456",
    "payment_method": "credit_card",
    "card_token": "card_token_from_frontend"
  }'
```

## SDKs and Libraries

We provide official SDKs for popular programming languages:

- **JavaScript/Node.js**: `npm install @travelden/api-client`
- **Python**: `pip install travelden-api`
- **PHP**: `composer require travelden/api-client`
- **Java**: Available on Maven Central
- **C#**: Available on NuGet

### JavaScript Example

```javascript
import TravelDenAPI from '@travelden/api-client';

const client = new TravelDenAPI({
  apiKey: 'your-api-key',
  baseURL: 'https://api.travelden.com/v1'
});

// Search for flights
const flights = await client.products.search({
  type: 'flight',
  origin: 'NYC',
  destination: 'LAX',
  departureDate: '2024-03-15'
});

// Create booking
const booking = await client.bookings.create({
  productId: flights.data[0].id,
  passengers: [{
    firstName: 'John',
    lastName: 'Doe',
    dateOfBirth: '1990-01-01',
    passportNumber: 'A12345678'
  }]
});
```

## Testing

### Sandbox Environment

Use our sandbox environment for testing:

```
https://api-sandbox.travelden.com/v1
```

### Test Data

We provide test data for common scenarios:

- **Test Credit Cards**: Use `4111111111111111` for successful payments
- **Test Users**: Use `test@travelden.com` with password `test123`
- **Test Products**: Search for flights from `TEST` to `DEST`

## Support

- **Documentation**: [https://docs.travelden.com](https://docs.travelden.com)
- **API Reference**: [endpoints.md](endpoints.md)
- **Support Email**: api-support@travelden.com
- **Status Page**: [https://status.travelden.com](https://status.travelden.com)

## Next Steps

- [Authentication Guide](authentication.md)
- [API Endpoints Reference](endpoints.md)
- [Service Documentation](../services/booking-service.md)
- [Error Handling Best Practices](#error-handling)