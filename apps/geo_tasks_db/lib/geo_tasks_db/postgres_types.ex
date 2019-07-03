# Enable PostGIS for Ecto
Postgrex.Types.define(
  GeoTasksDb.PostgresTypes,
  [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),
  json: Jason
)
#Postgrex.Types.define(GeoExample.PostgresTypes, [Geo.PostGIS.Extension] ++ Ecto.Adapters.Postgres.extensions(),