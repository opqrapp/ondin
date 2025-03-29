# Feature Flag Design

Feature Flag policy system should be able to define detailed activation rules based on various conditions. I propose a design that manages a set of conditions (Rules) for each Flag.

## Query Parameters
We need to set up query parameters that are received as input for each project. These query parameters are then used to apply rules to determine whether to activate/deactivate Features.

Here's an example of query parameters:
```json
{
  "projectId": "ecommerce-app",
  "parameters": [
    {
      "key": "userId",
      "type": "string",
      "description": "Unique identifier for the user",
      "required": true
    },
    {
      "key": "userRole",
      "type": "string",
      "description": "User role (admin, user, guest, etc.)",
      "required": false,
      "defaultValue": "guest"
    },
    {
      "key": "region",
      "type": "string",
      "description": "User region code",
      "required": false,
      "defaultValue": "global"
    },
  ]
}
```

## Feature Flag Definition Example
```json
{
  "feature": "NewHomepage",
  "rules": [
    {
      "id": "rule1",
      "conditions": [
        { "key": "userGroup", "operator": "in", "value": ["beta_testers"] },
        { "key": "country", "operator": "equals", "value": "KR" }
      ],
      "variation": true
    },
    {
      "id": "rule2",
      "conditions": [
        { "key": "userId", "operator": "equals", "value": "12345" }
      ],
      "variation": true
    }
  ],
  "defaultVariation": false
}
```

## Default State (Default On/Off)
This is the global default value for a Feature Flag. If no specific conditions are met, this value is used. For example, if the default value is Off, users who don't belong to special conditions cannot use the feature.

## Rules
Rules are sets of conditions that determine whether a Feature Flag is activated. Each rule can apply various conditions to query parameters defined in the project (user ID, group, region, etc.). For example, you can set conditions like "activate only for specific user IDs," "activate for users in the beta tester group," or "deactivate for users connecting from specific regions." When multiple rules exist, they are evaluated according to priority. Administrators can create and modify these rules intuitively through the UI, and the client SDK quickly evaluates these rules locally to determine if a Feature should be activated in the given context.

## Conditions
Policy condition definitions are stored in the repository in JSON or DSL format, and the client SDK interprets them to determine if the Flag should be turned on for a given user context. For example, a policy in JSON format would look something like this:

### key
The key is the name of the property or parameter used when evaluating a condition. It matches the field name of information in the query parameters.

**Examples**:
* `userGroup`: Group to which the user belongs (e.g., "beta_testers")
* `userId`: Unique identifier for the user
* `country`: User's country code
And any other query parameter information defined in the project (region, time, device type, etc.)

### operator
The operator determines how to evaluate the value corresponding to the key. It defines the comparison method.

**Examples**:
* equals: Check if exactly matching
* in: Check if the value is included in the given list

Other possible operators: not_equals, contains, greater_than, less_than, etc.

### value
The value is the target value to compare using the key and operator. It can be a single value or an array of values.

**Examples**:
* Strings: "KR", "12345"
* Arrays: ["beta_testers"]
* Other data types: numbers, booleans, etc.
