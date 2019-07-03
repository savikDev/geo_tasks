defmodule GeoTasksDb.Tokens do
  @moduledoc """
    Tokens schema description
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias GeoTasksDb.Roles

  @type t :: %__MODULE__{
               id: String.t() | nil,
               token:  String.t() | nil,
               active: boolean | nil,
               inserted_at: NaiveDateTime.t()| nil,
               updated_at: NaiveDateTime.t() | nil
             }
  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tokens" do
    field(:token, :string, null: false)
    field(:active, :boolean, default: false)
    belongs_to(:roles, Roles, foreign_key: :role_id, type: :binary_id)

    timestamps()
  end

  @spec changeset(token_fields, attrs) :: result when
    token_fields: t(),
    attrs: map(),
    result: Ecto.Changeset.t()

  def changeset(token_fields, attrs) do
    token_fields
    |> cast(attrs, [:token, :active])
    |> validate_required([:token, :active])
    |> unique_constraint(:token)
  end

end
