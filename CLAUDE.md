# Ondin Development Guidelines

## Commands
- Build: TBD (project implementation not started)
- Run: TBD
- Lint: TBD (likely ESLint for JS/TS, mix format for Elixir)
- Test: TBD (likely Jest for JS/TS, ExUnit for Elixir)
- Single test: TBD (likely `mix test path/to/test.exs:line_number` for Elixir, `jest path/to/test.js` for JS)

## Code Style Guidelines
- **Languages**: Elixir/Phoenix (backend), React/TypeScript (frontend)
- **Naming**: Use snake_case for Elixir, camelCase for JS/TS
- **Types**: Use TypeScript interfaces for frontend, typespecs for Elixir
- **Formatting**: Auto-format code with mix format (Elixir) and Prettier (JS/TS)
- **Error Handling**: Use pattern matching for Elixir errors, try/catch with typed errors for JS
- **Imports**: Group imports by type (std lib, external libs, internal modules)
- **Documentation**: Document public functions with @doc (Elixir) and JSDoc (JS/TS)
- **Project Structure**: Organize by domain/feature rather than technical layers
- **Testing**: Unit tests required for business logic, focus on behavior over implementation

## Architecture Principles
- Feature flags definitions are stored in database
- Client SDK evaluates flag rules locally
- Real-time updates prioritize reliability over immediate delivery