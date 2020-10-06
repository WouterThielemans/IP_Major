defmodule ProjectR0719212.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      ProjectR0719212.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: ProjectR0719212.Supervisor)
  end
end
