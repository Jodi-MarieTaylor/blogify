# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :blog,
  ecto_repos: [Blog.Repo]

  config :blog, Blog.Mailer,
    adapter: Bamboo.LocalAdapter

config :cloudinex,
       debug: false, #optional
       base_url: "https://api.cloudinary.com/v1_1/",
       api_key: "574192756355717",
       secret: "MuUbGRtC-JsLkOWsaDp93AqZZow",
       cloud_name: "dc6zvehph"


# Configures the endpoint
config :blog, Blog.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "JaHybDBPP6qkcFafsshoJ7KfbWG2QeHwLivm9RaoWtrBr8nxqHaIGd0tqLaP4Yj8",
  render_errors: [view: Blog.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Blog.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
