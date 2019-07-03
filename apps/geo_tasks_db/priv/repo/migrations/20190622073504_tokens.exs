defmodule GeoTasksDb.Repo.Migrations.Tokens do
  use Ecto.Migration

  def change do
    create table(:tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token,   :string, size: 24
      add :role_id, references(:roles, type: :binary_id, null: false)
      add :active, :boolean

      timestamps()
    end
  end
end
