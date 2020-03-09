use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with webpack to recompile .js and .css sources.
config :ex_2fa, Ex2faWeb.Endpoint,
  https: [
    port: System.fetch_env!("PORT"),
    cipher_suite: :strong,
    keyfile: "priv/cert/selfsigned_key.pem",
    certfile: "priv/cert/selfsigned.pem"
  ],
  url: [host: System.fetch_env!("HOST"), scheme: "https", port: System.fetch_env!("PORT")],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

config :logger,
  backends: [:console],
  level: :debug

# Watch static and templates for browser reloading.
config :ex_2fa, Ex2faWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/ex_2fa_web/{live,views}/.*(ex)$",
      ~r"lib/ex_2fa_web/templates/.*(eex)$"
    ]
  ]

# Configure your database
config :ex_2fa, Ex2fa.Repo, show_sensitive_data_on_connection_error: false

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
