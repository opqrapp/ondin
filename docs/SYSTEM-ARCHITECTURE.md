# System Architecture Overview
The system is designed with a dual structure of Control Plane (control service) and Client SDK (client agent) to meet requirements. The main components of the overall architecture are as follows:

## Feature Flag Control Service
A central management service based on Elixir/Phoenix that serves as the control plane managing all Feature Flag definitions and states. This service processes Feature Flag creation/change requests through admin UI and API, and records flag settings in permanent storage.

## Data Store
A permanent storage for Feature Flag settings and policies. It uses RDBMS like PostgreSQL for reliability and consistency. The chosen storage must have high availability and reliably maintain Feature Flag settings.

## API and Communication Layer
API endpoints are provided for client applications to retrieve Feature Flag information. It supports initial complete Flag configuration fetch through Phoenix-based JSON API. It also provides communication channels (SSE) for real-time updates, maintaining continuous connections between server and client.

## Client SDK/Agent
A Feature Flag SDK that operates within each application (web frontend, backend services, etc.).
This SDK loads all Feature Flag settings from the server upon initialization and stores them in local cache,
providing simple functions for application code to check Flag status
(for example: FeatureFlag.is_enabled?(:flag_name, user_context)).

The SDK handles synchronization with the central service in the background, continuously updating its internal local memory cache. Flag evaluation (decision) is performed locally within the SDK based on local data, making it immediate without network delay.

## Admin UI
A web application UI for administrators or DevOps teams to configure Feature Flags.
It's implemented using Phoenix LiveView for real-time interaction.
The main client UI is built with React and calls backend APIs.
This UI allows registering new Flags, toggling on/off, editing target conditions, setting schedules, etc., with all changes processed through the control service's API.
