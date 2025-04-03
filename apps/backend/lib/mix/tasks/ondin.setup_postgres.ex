defmodule Mix.Tasks.Ondin.SetupPostgres do
  @moduledoc """
  Postgres 개발 환경 설정을 생성합니다.

  ## 사용법

      mix ondin.setup_postgres [옵션]

  ## 옵션

    * `--database` - 데이터베이스 이름 (기본값: "ondin_dev")
    * `--username` - PostgreSQL 사용자 이름 (기본값: "postgres")
    * `--password` - PostgreSQL 비밀번호 (기본값: "postgres")
    * `--hostname` - PostgreSQL 호스트 (기본값: "localhost")
    * `--port` - PostgreSQL 포트 (기본값: 5432)
  """
  use Mix.Task

  @shortdoc "Postgres 개발 환경 설정"

  @impl Mix.Task
  def run(args) do
    {opts, _, _} = OptionParser.parse(args,
      switches: [
        database: :string,
        username: :string,
        password: :string,
        hostname: :string,
        port: :integer
      ],
      aliases: [
        d: :database,
        u: :username,
        p: :password,
        h: :hostname
      ]
    )

    database = opts[:database] || "ondin_dev"
    username = opts[:username] || "postgres"
    password = opts[:password] || "postgres"
    hostname = opts[:hostname] || "localhost"
    port = opts[:port] || 5432

    # Update config/dev.exs
    case update_dev_config(database, username, password, hostname, port) do
      :ok ->
        # Create database if it doesn't exist
        case create_database(database, username, password, hostname, port) do
          :ok ->
            Mix.shell().info("""

            ✅ Postgres 설정이 완료되었습니다:

               데이터베이스: #{database}
               사용자: #{username}
               비밀번호: #{password}
               호스트: #{hostname}
               포트: #{port}

            config/dev.exs 파일에 설정이 업데이트되었습니다.
            """)

          :error ->
            # 데이터베이스 생성 중 에러가 발생하면 여기서 함수 종료
            exit({:shutdown, 1})
        end

      :error ->
        # 설정 파일 업데이트 중 에러가 발생하면 여기서 함수 종료
        exit({:shutdown, 1})
    end
  end

  defp update_dev_config(database, username, password, hostname, port) do
    dev_config_path = Path.join([File.cwd!(), "config", "dev.exs"])

    case File.read(dev_config_path) do
      {:ok, content} ->
        # Pattern to replace Repo configuration
        repo_pattern = ~r/config :ondin, Ondin\.Repo,\n.*?(?=\n\n)/s

        db_config = """
        config :ondin, Ondin.Repo,
          username: "#{username}",
          password: "#{password}",
          hostname: "#{hostname}",
          port: #{port},
          database: "#{database}",
          stacktrace: true,
          show_sensitive_data_on_connection_error: true,
          pool_size: 10
        """

        new_content = Regex.replace(repo_pattern, content, db_config)

        if content != new_content do
          case File.write(dev_config_path, new_content) do
            :ok ->
              Mix.shell().info("config/dev.exs 파일의 데이터베이스 설정이 업데이트되었습니다.")
              :ok
            {:error, reason} ->
              Mix.shell().error("config/dev.exs 파일을 저장하는 중 오류가 발생했습니다: #{reason}")
              :error
          end
        else
          Mix.shell().info("변경된 설정이 없습니다.")
          :ok
        end

      {:error, reason} ->
        Mix.shell().error("config/dev.exs 파일을 읽는 중 오류가 발생했습니다: #{reason}")
        :error
    end
  end

  defp create_database(database, username, password, hostname, port) do
    # Check if PostgreSQL client is installed
    case System.cmd("which", ["psql"], stderr_to_stdout: true) do
      {_, 0} ->
        # PostgreSQL client is installed
        Mix.shell().info("Postgres 클라이언트가 설치되어 있습니다. 데이터베이스 생성을 시도합니다...")

        # Create connection string
        connection_string = "postgres://#{username}:#{password}@#{hostname}:#{port}/postgres"

        # Check if database exists
        db_exists_command = "psql #{connection_string} -tAc \"SELECT 1 FROM pg_database WHERE datname='#{database}'\""

        case System.cmd("sh", ["-c", db_exists_command], stderr_to_stdout: true) do
          {"1\n", 0} ->
            Mix.shell().info("데이터베이스 '#{database}'가 이미 존재합니다.")
            :ok

          {_, 0} ->
            # Create database
            create_db_command = "psql #{connection_string} -c \"CREATE DATABASE #{database}\""

            case System.cmd("sh", ["-c", create_db_command], stderr_to_stdout: true) do
              {output, 0} ->
                Mix.shell().info("데이터베이스 '#{database}'가 성공적으로 생성되었습니다.")
                :ok

              {error, _} ->
                Mix.shell().error("""
                데이터베이스 생성 중 오류가 발생했습니다:
                #{error}

                수동으로 다음 명령을 실행해보세요:
                $ psql -U #{username} -h #{hostname} -p #{port} -c "CREATE DATABASE #{database}"
                """)
                :error
            end

          {error, _} ->
            Mix.shell().error("""
            데이터베이스 확인 중 오류가 발생했습니다:
            #{error}

            PostgreSQL 접속 정보를 확인하세요:
            사용자: #{username}
            비밀번호: #{password}
            호스트: #{hostname}
            포트: #{port}
            """)
            :error
        end

      {_, _} ->
        # PostgreSQL client is not installed
        Mix.shell().error("""
        PostgreSQL 클라이언트(psql)가 설치되어 있지 않습니다.
        데이터베이스 설정은 업데이트되었지만, 데이터베이스는 생성할 수 없습니다.

        PostgreSQL 클라이언트를 설치한 후 다음 명령을 실행하여 데이터베이스를 생성하세요:
        $ psql -U #{username} -h #{hostname} -p #{port} -c "CREATE DATABASE #{database}"
        """)
        :error
    end
  end
end
