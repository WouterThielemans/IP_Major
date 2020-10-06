defmodule ProjectR0719212Web.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      ProjectR0719212Web.Endpoint
      # Starts a worker by calling: ProjectR0719212Web.Worker.start_link(arg)
      # {ProjectR0719212Web.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ProjectR0719212Web.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ProjectR0719212Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
