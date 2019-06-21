# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :geo_tasts_api,
  namespace: GeoTasksApi

# Configures the endpoint
config :geo_tasts_api, GeoTasksApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "mlwz4P9f7NKM6xKYQhtvUZAcG+P4aXtvgm8GUfTwQRUtrVB2A/3Hd+kqQoJdWsiu",
  render_errors: [view: GeoTasksApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: GeoTasksApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :geo_tasts_api, :generators,
  context_app: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
