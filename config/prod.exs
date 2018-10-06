use Mix.Config
require Logger

# For production, don't forget to configure the url host
# to something meaningful, Phoenix uses this information
# when generating URLs.
#
# Note we also include the path to a cache manifest
# containing the digested version of static files. This
# manifest is generated by the `mix phx.digest` task,
# which you should run after static files are built and
# before starting your production server.
config :platform, PlatformWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [
    scheme: "https",
    host: System.get_env("PLATFORM_HOST") || "example.com",
    port: 443
  ],
  server: true,
  force_ssl: [rewrite_on: [:x_forwarded_proto]],
  secret_key_base: System.get_env("SECRET_KEY_BASE") || Logger.info("Please set env variable SECRET_KEY_BASE"),
  cache_static_manifest: "priv/static/cache_manifest.json"

# Do not print debug messages in production
config :logger, level: :info

config :platform, Platform.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL") || ""
