defmodule GeoTasksDb.Repo.Migrations.DeliveryLocations do
  use Ecto.Migration

  def change do
    create table(:delivery_locations) do
      modify :lat, :decimal, null: false
      modify :lng, :decimal, null: false
    end
  end
end
