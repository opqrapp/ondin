defmodule Ondin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      OndinWeb.Telemetry,
      Ondin.Repo,
      {DNSCluster, query: Application.get_env(:ondin, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Ondin.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Ondin.Finch},
      # Start a worker by calling: Ondin.Worker.start_link(arg)
      # {Ondin.Worker, arg},
      # Start to serve requests, typically the last entry
      OndinWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Ondin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OndinWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
