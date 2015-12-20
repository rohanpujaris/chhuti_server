use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chhuti_server, ChhutiServer.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :chhuti_server, ChhutiServer.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "chhuti_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :chhuti_server,
  google_client_id: "646252629386-aalvnktjfsql35e0cmb28qirhvj7t2p6.apps.googleusercontent.com",
  google_client_secret: "WGuBUitGojEFwFV4w4GSGQhN"