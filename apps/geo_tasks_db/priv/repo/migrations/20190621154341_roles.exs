defmodule GeoTasksDb.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(:roles, primary_key: false) do
      add :id,   :binary_id, primary_key: true
      add :name, :string, size: 24

      timestamps()
    end
    create unique_index(:roles, [:name])
  end
end
