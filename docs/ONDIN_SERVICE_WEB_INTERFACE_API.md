# Ondin Service: Web Interface REST API Specification

Based on your PRD and service architecture document, here's a comprehensive REST API specification for the Ondin feature flag management system web interface.

## Core API Endpoints

### Authentication & User Management

The Ondin web interface is implemented as a hybrid Phoenix Framework application. Authentication and user management will utilize Phoenix's built-in authentication system rather than custom REST endpoints.

Key authentication flows:
- User login/registration via Phoenix.Auth
- Session management via Phoenix contexts
- Password reset functionality leveraging Phoenix mailers
- User profile management through Phoenix forms and controllers

The Phoenix authentication system will handle:
- Session-based authentication
- User credential validation and storage
- Authorization policies for different user roles
- CSRF protection

Note: These operations will not require explicit REST API calls as they'll be handled through Phoenix's standard controller actions and HTML views with LiveView support.

### Project Management

```
GET    /api/projects                # List all projects accessible to the user
POST   /api/projects                # Create a new project
GET    /api/projects/:id            # Get project details
PUT    /api/projects/:id            # Update project details
DELETE /api/projects/:id            # Delete a project
GET    /api/projects/:id/members    # List project members
POST   /api/projects/:id/members    # Add a member to project
DELETE /api/projects/:id/members/:userId # Remove a member from project
PUT    /api/projects/:id/members/:userId # Update member permissions
```

### Feature Flag Management

```
GET    /api/projects/:id/flags      # List all flags for a project
POST   /api/projects/:id/flags      # Create a new flag
GET    /api/projects/:id/flags/:flagId     # Get flag details
PUT    /api/projects/:id/flags/:flagId     # Update flag details
DELETE /api/projects/:id/flags/:flagId     # Delete a flag
PATCH  /api/projects/:id/flags/:flagId/toggle # Quick toggle flag on/off
GET    /api/projects/:id/flags/:flagId/history # Get flag change history
```

### Policy Management

```
GET    /api/projects/:id/flags/:flagId/policies     # List all policies for a flag
POST   /api/projects/:id/flags/:flagId/policies     # Create a new policy
GET    /api/projects/:id/flags/:flagId/policies/:policyId   # Get policy details
PUT    /api/projects/:id/flags/:flagId/policies/:policyId   # Update policy
DELETE /api/projects/:id/flags/:flagId/policies/:policyId   # Delete policy
```

### SDK Integration

```
GET    /api/projects/:id/keys        # List API keys for a project
POST   /api/projects/:id/keys        # Generate a new API key
DELETE /api/projects/:id/keys/:keyId # Revoke an API key
```

### Analytics & Monitoring

```
GET    /api/projects/:id/analytics           # Get overall analytics for a project
GET    /api/projects/:id/flags/:flagId/usage # Get usage statistics for a flag
GET    /api/audit                            # Get system-wide audit logs
GET    /api/projects/:id/audit               # Get project-specific audit logs
```

## Data Models

### User

```json
{
  "id": "user_123",
  "email": "user@example.com",
  "name": "John Doe",
  "role": "admin", // system role: admin, user
  "created_at": "2023-06-01T12:00:00Z",
  "updated_at": "2023-06-01T12:00:00Z"
}
```

### Project

```json
{
  "id": "proj_123",
  "name": "Payment Service",
  "description": "Feature flags for the payment service",
  "created_by": "user_123",
  "created_at": "2023-06-01T12:00:00Z",
  "updated_at": "2023-06-01T12:00:00Z",
  "members_count": 5
}
```

### Project Member

```json
{
  "user_id": "user_123",
  "project_id": "proj_123",
  "role": "admin", // project role: admin, editor, viewer
  "added_at": "2023-06-01T12:00:00Z",
  "added_by": "user_456",
  "user": {
    "id": "user_123",
    "name": "John Doe",
    "email": "john@example.com"
  }
}
```

### Feature Flag

```json
{
  "id": "flag_123",
  "project_id": "proj_123",
  "name": "enable_new_checkout",
  "key": "enable-new-checkout",
  "description": "Toggle the new checkout experience",
  "enabled": true,
  "default_value": false,
  "type": "boolean", // boolean, string, number, json
  "created_by": "user_123",
  "created_at": "2023-06-01T12:00:00Z",
  "updated_at": "2023-06-02T09:30:00Z",
  "policies_count": 2
}
```

### Policy

```json
{
  "id": "policy_123",
  "flag_id": "flag_123",
  "project_id": "proj_123",
  "name": "Beta Testers",
  "description": "Enable for beta testing users",
  "priority": 10,
  "value": true,
  "conditions": [
    {
      "attribute": "user.group",
      "operator": "in",
      "values": ["beta-testers", "internal-users"]
    },
    {
      "attribute": "region",
      "operator": "equals",
      "value": "us-west"
    }
  ],
  "created_by": "user_123",
  "created_at": "2023-06-01T12:00:00Z",
  "updated_at": "2023-06-02T09:30:00Z"
}
```

### API Key

```json
{
  "id": "key_123",
  "project_id": "proj_123",
  "name": "Production API Key",
  "key": "ondin_prod_a1b2c3d4e5f6...", // only shown once on creation
  "permissions": ["read", "evaluate"],
  "created_by": "user_123",
  "created_at": "2023-06-01T12:00:00Z",
  "last_used": "2023-06-10T15:45:00Z"
}
```

### Audit Log Entry

```json
{
  "id": "audit_123",
  "project_id": "proj_123",
  "user_id": "user_123",
  "action": "flag.toggle",
  "resource_type": "flag",
  "resource_id": "flag_123",
  "metadata": {
    "previous_state": { "enabled": false },
    "new_state": { "enabled": true }
  },
  "timestamp": "2023-06-02T09:30:00Z",
  "ip_address": "192.168.1.1",
  "user_agent": "Mozilla/5.0..."
}
```

### Flag History

```json
{
  "id": "history_123",
  "flag_id": "flag_123",
  "project_id": "proj_123",
  "user_id": "user_123",
  "change_type": "update",
  "changes": {
    "enabled": {
      "from": false,
      "to": true
    }
  },
  "timestamp": "2023-06-02T09:30:00Z"
}
```

## Client SDK Authentication

For SDK authentication, the service should support:

1. API key authentication (for server environments)
2. JWT-based authentication (for authenticated web applications)
3. Anonymous client tokens with limited permissions (for public-facing applications)

## Error Responses

All API endpoints should return appropriate HTTP status codes and standardized error responses:

```json
{
  "error": {
    "code": "invalid_request",
    "message": "The project ID specified is invalid",
    "details": [
      { "field": "project_id", "issue": "format", "description": "Must be a valid UUID" }
    ]
  },
  "request_id": "req_a1b2c3d4"
}
```

## WebSocket Connection for Real-time Updates

In addition to the REST API, the system should provide a WebSocket connection for real-time updates:

```
WS /api/ws?token=<auth_token>
```

The WebSocket connection should support the following message types:

1. Flag updates (when a flag status changes)
2. Policy updates (when policies are modified)
3. Project updates (when project settings change)
4. User authorization changes

This real-time channel ensures that the web interface can display the most current state without constant polling, supporting the "Real-time Change Distribution" requirement from the PRD.

---

This API specification provides a comprehensive foundation for building the web interface for the Ondin service, covering all the requirements specified in the PRD while aligning with the system architecture described in the service documentation.
