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
            git
            sapling
            # Database
            postgresql
          ];


          # Shell hook for environment setup
          shellHook = ''
            export PRJ_ROOT=$(realpath $(pwd))
            alias cdprj="cd $PRJ_ROOT"
            echo "Elixir backend development loaded!"
            echo "Elixir version: $(elixir --version)"

            # 환경 변수에 따라 시작할 프로그램 결정
            if [ "$START_PROGRAM" = "phoenix" ]; then
              echo "Starting Phoenix server..."
              iex -S mix phx.server
            elif [ "$START_PROGRAM" = "postgres" ]; then
              echo "Starting PostgreSQL on port 12345..."
              # PostgreSQL 데이터 디렉토리 생성 및 초기화
              mkdir -p $PRJ_ROOT/pgdata
              if [ ! -d "$PRJ_ROOT/pgdata/base" ]; then
                echo "Initializing PostgreSQL database..."
                initdb -D $PRJ_ROOT/pgdata
              fi
              # PostgreSQL 시작
              pg_ctl -D $PRJ_ROOT/pgdata -o "-p 12345" start
              
              # 쉘 종료 시 PostgreSQL 자동 종료 설정
              cleanup() {
                echo "Stopping PostgreSQL..."
                pg_ctl -D $PRJ_ROOT/pgdata stop -m fast
              }
              trap cleanup EXIT
            fi
          '';
        };
      }
    );
}
