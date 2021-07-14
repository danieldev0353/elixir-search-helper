# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir_search_extractor,
  ecto_repos: [ElixirSearchExtractor.Repo]

# Configures the endpoint
config :elixir_search_extractor, ElixirSearchExtractorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ZpFZ9Soj1+7xkzve9LnUwcddIiZB+Lw1zXsGQeJqGIcQDXbBpzTMWKZ6cfdsd4X4",
  render_errors: [view: ElixirSearchExtractorWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: ElixirSearchExtractor.PubSub,
  live_view: [signing_salt: "wMjNxOLB"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :elixir_search_extractor, Oban,
  repo: ElixirSearchExtractor.Repo,
  plugins: [Oban.Plugins.Pruner],
  queues: [default: 10]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"

config :elixir_search_extractor, ExOauth2Provider,
  repo: ElixirSearchExtractor.Repo,
  resource_owner: ElixirSearchExtractor.Account.Schemas.User,
  password_auth: {ElixirSearchExtractor.Account.Oauth2.Auth, :authenticate}
