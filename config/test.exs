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
  password: "password",
  database: "chhuti_server_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :google_auth, :mock_data,
  valid_token_data: %{
    kiprosh_email: %{name: "rohan", email: "rohan@kiprosh.com", picture: "http://a.com/pic.jpg"},
    non_kiprosh_email: %{name: "rohan", email: "rohan@gmail.com", picture: "http://a.com/pic.jpg"}
  }

config :google_auth,
  google_client_id: "646252629386-aalvnktjfsql35e0cmb28qirhvj7t2p6.apps.googleusercontent.com"
