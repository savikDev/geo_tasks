defmodule GeoTasksDb.Repo.Migrations.Roles do
  use Ecto.Migration

  def change do
    create table(roles) do
      add :name,    :string, size: 16

      timestamps()
    end
  end
end
