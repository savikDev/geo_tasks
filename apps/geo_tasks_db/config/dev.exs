use Mix.Config

# Configure your database
config :geo_tasks_db, GeoTasksDb.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "geo_tasks_db_dev",
  hostname: "localhost",
  pool_size: 10
