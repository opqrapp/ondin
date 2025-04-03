default:

# 개발 환경 설정 (아무 프로그램도 자동 실행하지 않고 쉘에 남음)
dev:
	iex -S mix phx.server

# nix 셸만 실행 (START_PROGRAM 설정 없이)
shell:
	START_PROGRAM=shell nix develop

# Phoenix 서버 실행
server:
	START_PROGRAM=phoenix nix develop

# PostgreSQL 데이터베이스 시작
db:
	START_PROGRAM=postgres nix develop

db.init:
	psql -p 12345 -c "CREATE USER postgres WITH SUPERUSER PASSWORD 'postgres'" postgres
	psql -p 12345 -c "CREATE DATABASE ondin_dev OWNER postgres" postgres

# 데이터베이스 완전 초기화
db.reset:
	mix ondin.setup_postgres --port 12345
	mix ecto.drop
	mix ecto.create
	mix ecto.migrate
