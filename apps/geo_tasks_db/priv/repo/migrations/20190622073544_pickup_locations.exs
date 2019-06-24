defmodule GeoTasksDb.Repo.Migrations.PickupLocations do
  use Ecto.Migration

  def change do
    create table(:pickup_locations) do
      modify :lat, :decimal, null: false
      modify :lng, :decimal, null: false
    end
  end
end
