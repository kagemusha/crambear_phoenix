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

config :phoenix, :format_encoders,
  "json-api": Poison

config :plug, :mimes, %{
  "application/vnd.api+json" => ["json-api"]
}

config :guardian, Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "CrambearPhoenix",
  ttl: { 30, :days },
  verify_issuer: true, # optional
  # this is an example key which would need to change for a real app
  secret_key: %{
      "crv" => "P-521",
      "d" => "axDuTtGavPjnhlfnYAwkHa4qyfz2fdseppXEzmKpQyY0xd3bGpYLEF4ognDpRJm5IRaM31Id2NfEtDFw4iTbDSE",
      "kty" => "EC",
      "x" => "AL0H8OvP5NuboUoj8Pb3zpBcDyEJN907wMxrCy7H2062i3IRPF5NQ546jIJU3uQX5KN2QB_Cq6R_SUqyVZSNpIfC",
      "y" => "ALdxLuo6oKLoQ-xLSkShv_TA0di97I9V92sg1MKFava5hKGST1EKiVQnZMrN3HO8LtLT78SNTgwJSQHAXIUaA-lV"
    },
    serializer: CrambearPhoenix.GuardianSerializer,
    hooks: GuardianDb

config :sentinel,
  app_name: "Crambear Phoenix",
  user_model: CrambearPhoenix.User,
  email_sender: "info@crambear.com",
  crypto_provider: Comeonin.Bcrypt,
  auth_handler: Sentinel.AuthHandler, #optional
  repo: CrambearPhoenix.Repo,
  confirmable: :false, # possible options {:false, :required, :optional}, optional config, defaulting to :optional
  invitable: :false, # possible options {:false, :true}, optional config, defaulting to false
  endpoint: CrambearPhoenix.Endpoint,
  router: CrambearPhoenix.Router,
  user_view: CrambearPhoenix.Api.UserView,
  environment: :development

config :guardian_db, GuardianDb,
  repo: CrambearPhoenix.Repo

config :canary, repo: CrambearPhoenix.Repo


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
