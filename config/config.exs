# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lists,
  ecto_repos: [Lists.Repo]

# Configures the endpoint
config :lists, ListsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9KMO25HGue74pHTzhEu7jo2n32N1Ys8o4+cDKfSZqhT5GTiMFcm9F01TmVdiyTK9",
  render_errors: [view: ListsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Lists.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "19IQWxeu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
