defmodule GeoTasksDb.Repo.Migrations.Tasks do
  use Ecto.Migration

  def change do
    create table(:tasks,  primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name,  :string, size: 40
      add :title, :string
      add :status, :string
      add :token_created_id,     references(:tokens, type: :binary_id, null: false)
      add :token_asigned_id,     references(:tokens, type: :binary_id)
      add :pickup_location_id,   references(:pickup_locations, type: :binary_id, null: false)
      add :delivery_location_id, references(:delivery_locations, type: :binary_id, null: false)

      timestamps()
    end
  end
end
