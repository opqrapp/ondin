defmodule Ondin.Repo do
  use Ecto.Repo,
    otp_app: :ondin,
    adapter: Ecto.Adapters.Postgres
end
