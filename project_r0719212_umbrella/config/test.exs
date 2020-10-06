use Mix.Config

# Configure your database
config :project_r0719212, ProjectR0719212.Repo,
  username: "root",
  password: "",
  database: "project_r0719212_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :project_r0719212_web, ProjectR0719212Web.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
