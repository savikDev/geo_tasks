defmodule GeoTasksDb.Repo.Migrations.Tokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :toren,   :string, size: 24
      add :role_id, references(:roles)
    end
  end
end
