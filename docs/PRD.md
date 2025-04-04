# Ondin - Feature Flagging System

Ondin is a product name that means On + Decision. It has the following main features and goals:

## Policy-based Feature Flag Management

A policy system is needed that can activate/deactivate Feature Flags based on conditions such as user groups, regions, and time. For example, it should be possible to expose new features only to specific user groups or regions, or to activate features only during set time windows, allowing for precise toggle control.

## Project Support

Users should be able to create projects and manage Feature flags for each project. Each project has an independent set of Feature Flags, and users should be able to easily switch between multiple projects for management. Project-level permission management and settings should also be supported to enable team collaboration.

## Real-time Change Distribution (Reliability First)

When Feature Flag settings change, these changes should be distributed in real-time to clients of each service. However, reliability is just as important as real-time delivery, so the architecture must ensure that changes are accurately delivered even during temporary network disconnections. If needed, a hybrid distribution method combining real-time capabilities and stability may be considered.

## Client Local Cache

Each application client should replicate/cache the central server's Feature Flag information locally, allowing flag status to be checked locally without querying the server for every request. This ensures that functionality can be maintained using the most recent state even during central system failures.

## Intuitive Management UI

A web-based UI that even non-developers can use should allow for the creation, modification, and setting of policy conditions for Feature Flags. The UX pattern should make it easy to see the status of multiple flags at a glance, toggle them, and configure conditions (rules).
