use Mix.Config

config :geo_tasks_db, ecto_repos: [GeoTasksDb.Repo]

config :location_based_searching, GeoTasksDb.Repo,
       extensions: [{Geo.PostGIS.Extension, library: Geo}]

config :geo_postgis,
       json_library: Jason
import_config "#{Mix.env}.exs"
