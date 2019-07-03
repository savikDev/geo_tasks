defmodule GeoTasksDb.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name,    :string, size: 40
      add :title, :string
      add :status, :string
      add :token_created_id,     references(:tokens)
      add :token_asigned_id,     references(:tokens)
      add :pickup_location_id,   references(:pickup_locations)
      add :delivery_location_id, references(:delivery_locations)
    end
  end
end
