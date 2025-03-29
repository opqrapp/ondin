default:


backend:
	cd nix/backend && nix develop

frontend:
	cd nix/frontend && nix develop

db:
	cd nix/db && nix develop
