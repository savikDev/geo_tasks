defmodule GeoTasksDb.Repo.Migrations.DeliveryLocations do
  use Ecto.Migration

  def up do
    create table(:delivery_locations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :location, :geometry

      timestamps()
    end
  end

  def down do
    drop table(:delivery_locations)
  end
end
