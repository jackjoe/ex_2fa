# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :ex_2fa,
  ecto_repos: [Ex2fa.Repo],
  env: Mix.env()

# Configures the endpoint
config :ex_2fa, Ex2faWeb.Endpoint,
  url: [host: System.get_env("HOST")],
  secret_key_base: "HS03eYvXX0K9SxIcfqOSmCFTEi2nVwDo5rM0ae2BHstLudSlyYOnn4SPRO0i2DVE",
  render_errors: [view: Ex2faWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ex2fa.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ex_2fa, Ex2fa.Repo,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: System.get_env("DB_NAME"),
  hostname: System.get_env("DB_HOST"),
  show_sensitive_data_on_connection_error: false,
  pool_size: 10

import_config "#{Mix.env()}.exs"
