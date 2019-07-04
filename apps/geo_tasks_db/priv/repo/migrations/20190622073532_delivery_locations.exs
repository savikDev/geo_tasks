defmodule GeoTasksDb.Repo.Migrations.DeliveryLocations do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION IF NOT EXISTS postgis"
    create table(:delivery_locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :geometry

      timestamps()
    end
  end

  def down do
    execute "DROP EXTENSION IF EXISTS postgis"
    drop table(:delivery_locations)
  end
end
