# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :crambear_phoenix,
  ecto_repos: [CrambearPhoenix.Repo]

# Configures the endpoint
config :crambear_phoenix, CrambearPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FnYw0CZKH9IcuPwMrGzQ1IDZdXOhki1L/hzqz2dJWk4JagyJ/fek0rSlmwXCpLe4",
  render_errors: [view: CrambearPhoenix.ErrorView, accepts: ~w(html json)],
  pubsub: [name: CrambearPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
