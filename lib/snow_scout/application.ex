defmodule SnowScout.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      SnowScout.Repo,
      # Start the Telemetry supervisor
      SnowScoutWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: SnowScout.PubSub},
      # Start the Endpoint (http/https)
      SnowScoutWeb.Endpoint
      # Start a worker by calling: SnowScout.Worker.start_link(arg)
      # {SnowScout.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SnowScout.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SnowScoutWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
