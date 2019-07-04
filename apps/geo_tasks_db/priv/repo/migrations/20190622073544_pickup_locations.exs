defmodule GeoTasksDb.Repo.Migrations.PickupLocations do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    create table(:pickup_locations,  primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :geometry

      timestamps()
    end
  end

  def down do
    execute "DROP EXTENSION IF EXISTS postgis"
    drop table(:pickup_locations)
  end
end
