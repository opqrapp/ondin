{
  description = "Backend development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Elixir and Erlang
            elixir
            erlang
            
            # Common development tools
            inotify-tools # For file system events, used by Phoenix live reload
            postgresql # In case you're using PostgreSQL
          ];

          # Shell hook for environment setup
          shellHook = ''
            echo "Elixir backend development environment loaded!"
            echo "Elixir version: $(elixir --version)"
          '';
        };
      }
    );
}
