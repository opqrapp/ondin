{
  description = "Backend development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
