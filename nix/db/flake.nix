{
  description = "PostgreSQL development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        # PostgreSQL 설정 - 버전 17 사용
        postgresql = pkgs.postgresql_17;
        pgPort = 12345;
        pgDataDir = "./postgres-data";
        
        # PostgreSQL 시작 스크립트
        startPostgres = pkgs.writeShellScriptBin "start-postgres" ''
          # 이미 실행 중인 PostgreSQL 인스턴스 확인 및 종료
          PG_PID=$(lsof -i:${toString pgPort} -t || echo "")
          if [ -n "$PG_PID" ]; then
            echo "PostgreSQL is already running on port ${toString pgPort}. Stopping it..."
            kill -TERM $PG_PID
            sleep 2
          fi

          # 데이터 디렉토리가 없으면 초기화
          if [ ! -d "${pgDataDir}" ]; then
            echo "Initializing PostgreSQL data directory..."
            mkdir -p ${pgDataDir}
            ${postgresql}/bin/initdb -D ${pgDataDir}
            
            # PostgreSQL 환경설정 - 포트 번호 변경
            sed -i "s/#port = 5432/port = ${toString pgPort}/" ${pgDataDir}/postgresql.conf
          fi

          # PostgreSQL 시작
          echo "Starting PostgreSQL on port ${toString pgPort}..."
          ${postgresql}/bin/pg_ctl -D ${pgDataDir} -l ${pgDataDir}/logfile start

          echo "PostgreSQL is now running on port ${toString pgPort}"
          echo "To stop the server, run: stop-postgres"
        '';
        
        # PostgreSQL 종료 스크립트
        stopPostgres = pkgs.writeShellScriptBin "stop-postgres" ''
          echo "Stopping PostgreSQL..."
          ${postgresql}/bin/pg_ctl -D ${pgDataDir} stop
          echo "PostgreSQL stopped"
        '';

      in {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            postgresql
            startPostgres
            stopPostgres
            pkgs.lsof  # 포트 사용 확인을 위해 필요
          ];

          shellHook = ''
            echo "PostgreSQL development environment"
            echo "PostgreSQL 17 will be automatically started on port ${toString pgPort}"
            
            # PostgreSQL 자동 시작
            start-postgres
            
            # 셸 종료 시 PostgreSQL 자동 종료
            trap 'stop-postgres' EXIT
          '';
        };
      }
    );
}
