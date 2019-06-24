defmodule GeoTasksDb.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name,    :string, size: 40
      add :title, :integer
      add :status, :integer
      add :token_created_id,     references(:groups)
      add :token_asifned_id,     references(:groups)
      add :pickup_location_id,   references(:pickup_locations)
      add :delivery_location_id, references(:delivery_locations)
    end
  end
end
