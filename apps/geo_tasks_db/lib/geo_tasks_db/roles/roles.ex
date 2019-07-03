defmodule GeoTasksDb.Roles do
  @moduledoc """
    Roles schema description
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
               id: String.t() | nil,
               name: String.t() | nil,
               inserted_at: NaiveDateTime.t()| nil,
               updated_at: NaiveDateTime.t() | nil
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "roles" do
    field(:name, :string, null: false)

    timestamps()
  end

  @spec changeset(role_fields, attrs) :: result when
    role_fields: t(),
    attrs: map(),
    result: Ecto.Changeset.t()

  def changeset(role_fields, attrs) do
    role_fields
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

end
