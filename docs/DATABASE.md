# Feature Flagging Database

## Postgres

We chose Postgres for our feature flagging system's database because:

- It offers excellent flexibility, allowing us to adapt our data model as needs evolve
- It provides rock-solid stability, which is critical for a system that other applications depend on
- It has a large, active community that continually improves the database and offers support
- It includes all the necessary features we need for building a reliable feature flagging system

## Entity-Relationship Diagram

### Key Entities Summary

| Entity         | Description                                                                 |
| -------------- | --------------------------------------------------------------------------- |
| User           | System user who creates projects and feature flags                          |
| Project        | A single app/service containing multiple feature flags                      |
| FeatureFlag    | The actual feature switch with default value and rules                      |
| QueryParameter | Defines input key/type needed when querying feature flags                   |
| FeatureRule    | Rules belonging to feature flags that return values when conditions are met |

### Table Schema Design (Summary)

#### 1. users

| Column | Description |
| ------ | ----------- |
| id     | Primary Key |
| name   |             |
| email  |             |

#### 2. projects

| Column  | Description            |
| ------- | ---------------------- |
| id      | Primary Key            |
| name    |                        |
| user_id | Foreign Key → users.id |

#### 3. feature_flags

| Column        | Description               |
| ------------- | ------------------------- |
| id            | Primary Key               |
| name          |                           |
| project_id    | Foreign Key → projects.id |
| default_value |                           |
| created_by    | Foreign Key → users.id    |

#### 4. query_parameters

| Column     | Description                  |
| ---------- | ---------------------------- |
| id         | Primary Key                  |
| project_id | Foreign Key → projects.id    |
| key        |                              |
| type       | e.g. string, number, boolean |

#### 5. feature_rules

| Column          | Description                               |
| --------------- | ----------------------------------------- |
| id              | Primary Key                               |
| feature_flag_id | Foreign Key → feature_flags.id            |
| priority        | integer                                   |
| condition_json  | JSON or text — Query parameter conditions |
| value           | Value to return when condition is true    |

### ERD Relationship Diagram

```
┌────────┐    1    ┌─────────┐    1    ┌────────────┐    1    ┌────────────┐
│ users  ├─────────┤projects ├─────────┤feature_flag├─────────┤feature_rule│
└───┬────┘    *    └────┬────┘    *    └─────┬──────┘    *    └────────────┘
    │                   │                    │
    │                   │                    │
    │                   │                    │created_by (FK)
    │        1          │               │
    └───────────────────┘               ↓
             *                     ┌────────┐
    ┌─────────────────┐            │ users  │
    │query_parameters │            └────────┘
    └─────────────────┘
```

### Simple Example Scenario

- User Jay creates a project called ChatApp
- Jay creates a feature flag called dark_mode (with default value set to false)
- A query parameter called user_type is defined
- A rule is defined so that when user_type equals "premium", dark_mode will be true

This structure flexibly supports various rules and parameters while clearly representing relationships between users, projects, and flags.
