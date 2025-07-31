# Architecture Overview

TravelDen is built using a microservices architecture pattern, designed for scalability, maintainability, and fault tolerance.

## System Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        WEB[Web Application]
        MOBILE[Mobile App]
        API_CLIENT[API Clients]
    end
    
    subgraph "Gateway Layer"
        GATEWAY[API Gateway]
        LB[Load Balancer]
    end
    
    subgraph "Service Layer"
        USER[User Service]
        PRODUCT[Product Service]
        BOOKING[Booking Service]
        PAYMENT[Payment Service]
    end
    
    subgraph "Data Layer"
        USER_DB[(User DB)]
        PRODUCT_DB[(Product DB)]
        BOOKING_DB[(Booking DB)]
        PAYMENT_DB[(Payment DB)]
        CACHE[(Redis Cache)]
    end
    
    subgraph "Infrastructure"
        QUEUE[Message Queue]
        MONITOR[Monitoring]
        LOGS[Logging]
    end
    
    WEB --> LB
    MOBILE --> LB
    API_CLIENT --> LB
    LB --> GATEWAY
    
    GATEWAY --> USER
    GATEWAY --> PRODUCT
    GATEWAY --> BOOKING
    GATEWAY --> PAYMENT
    
    USER --> USER_DB
    PRODUCT --> PRODUCT_DB
    BOOKING --> BOOKING_DB
    PAYMENT --> PAYMENT_DB
    
    USER --> CACHE
    PRODUCT --> CACHE
    BOOKING --> CACHE
    PAYMENT --> CACHE
    
    USER --> QUEUE
    PRODUCT --> QUEUE
    BOOKING --> QUEUE
    PAYMENT --> QUEUE
    
    QUEUE --> USER
    QUEUE --> PRODUCT
    QUEUE --> BOOKING
    QUEUE --> PAYMENT
```

## Service Communication

```mermaid
sequenceDiagram
    participant Client
    participant Gateway
    participant UserService
    participant ProductService
    participant BookingService
    participant PaymentService
    participant Queue
    
    Client->>Gateway: Search Products
    Gateway->>ProductService: GET /products/search
    ProductService-->>Gateway: Product Results
    Gateway-->>Client: Search Results
    
    Client->>Gateway: Create Booking
    Gateway->>BookingService: POST /bookings
    BookingService->>Queue: Booking Created Event
    BookingService-->>Gateway: Booking Confirmation
    Gateway-->>Client: Booking Response
    
    Queue->>PaymentService: Process Payment
    PaymentService->>Queue: Payment Processed Event
    Queue->>BookingService: Update Booking Status
```

## Design Principles

### 1. Microservices Architecture
- **Service Independence**: Each service can be developed, deployed, and scaled independently
- **Technology Diversity**: Services can use different technologies best suited for their domain
- **Fault Isolation**: Failure in one service doesn't cascade to others

### 2. Domain-Driven Design
- **Bounded Contexts**: Each service represents a distinct business domain
- **Ubiquitous Language**: Consistent terminology within each domain
- **Aggregate Boundaries**: Clear data ownership and consistency boundaries

### 3. Event-Driven Architecture
- **Asynchronous Communication**: Services communicate through events
- **Loose Coupling**: Services don't need direct knowledge of each other
- **Scalability**: Events can be processed at different rates

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Runtime** | PHP 8.2 + Laravel | Application framework |
| **Database** | MySQL 8.0 | Primary data storage |
| **Cache** | Redis | Session storage and caching |
| **Queue** | Redis/RabbitMQ | Asynchronous message processing |
| **Gateway** | Nginx | Load balancing and routing |
| **Containerization** | Docker | Service packaging and deployment |
| **Orchestration** | Docker Compose | Local development environment |

## Scalability Patterns

### Horizontal Scaling
```mermaid
graph LR
    LB[Load Balancer] --> S1[Service Instance 1]
    LB --> S2[Service Instance 2]
    LB --> S3[Service Instance 3]
    LB --> S4[Service Instance N]
```

### Database Scaling
```mermaid
graph TB
    APP[Application] --> MASTER[(Master DB)]
    APP --> REPLICA1[(Read Replica 1)]
    APP --> REPLICA2[(Read Replica 2)]
    MASTER --> REPLICA1
    MASTER --> REPLICA2
```

## Security Architecture

```mermaid
graph TB
    CLIENT[Client] --> WAF[Web Application Firewall]
    WAF --> GATEWAY[API Gateway]
    GATEWAY --> AUTH[Authentication Service]
    AUTH --> JWT[JWT Token]
    GATEWAY --> SERVICES[Microservices]
    SERVICES --> RBAC[Role-Based Access Control]
```

## Monitoring and Observability

- **Health Checks**: Each service exposes health endpoints
- **Metrics Collection**: Application and infrastructure metrics
- **Distributed Tracing**: Request tracing across services
- **Centralized Logging**: Aggregated logs from all services
- **Alerting**: Proactive monitoring and alerting

## Next Steps

- [System Design Details](system-design.md)
- [Database Schema](database-schema.md)
- [API Documentation](../api/getting-started.md)
- [Deployment Guide](../deployment/docker.md)