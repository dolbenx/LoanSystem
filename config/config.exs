# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :loanSystem,
  ecto_repos: [LoanSystem.Repo]

# Configures the endpoint
config :loanSystem, LoanSystemWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "n96MEHlkf2lK4yxDuodcYSQO4/KyHTfCt3g1WrJSahCCb2Wy+BHVHGxkBc2dPGUp",
  render_errors: [view: LoanSystemWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LoanSystem.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
