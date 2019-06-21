use Mix.Config

config :geo_tasks_db, ecto_repos: [GeoTasksDb.Repo]

import_config "#{Mix.env}.exs"
