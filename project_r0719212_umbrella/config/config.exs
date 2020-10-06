# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of Mix.Config.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
use Mix.Config

# Configure Mix tasks and generators
config :project_r0719212,
  ecto_repos: [ProjectR0719212.Repo]

config :project_r0719212_web, ProjectR0719212Web.Gettext,
  locales: ~w(en nl),
  default_locale: "en"

config :project_r0719212_web,
  ecto_repos: [ProjectR0719212.Repo],
  generators: [context_app: :project_r0719212]

# Configures the endpoint
config :project_r0719212_web, ProjectR0719212Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "OtP1Si7ZGu/+5vGl5JRpSACFwLEgF2V5kQMHJkKDr5GkCMQwi6/OwQ/eah4i0wNr",
  render_errors: [view: ProjectR0719212Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ProjectR0719212Web.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "a+lj3Lm3"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :project_r0719212_web, ProjectR0719212Web.Guardian,
  issuer: "project_r0719212_web",
  secret_key: "RSgzAyB0/TuXtQf6j+yX2XkE0SjTNf49em7naeJZ2OO22hjJkDNCt+9DHr9BdF1p"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
