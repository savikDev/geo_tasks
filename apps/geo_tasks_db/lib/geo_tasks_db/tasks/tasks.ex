defmodule GeoTasksDb.Tasks do
  @moduledoc """
    Tasks schema description
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias GeoTasksDb.DeliveryLocations
  alias GeoTasksDb.PickupLocations
  alias GeoTasksDb.Tokens


  @type t :: %__MODULE__{
               id: String.t() | nil,
               name:  String.t() | nil,
               title:  String.t() | nil,
               status:  String.t() | nil,

               inserted_at: NaiveDateTime.t()| nil,
               updated_at: NaiveDateTime.t() | nil
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "tasks" do
    field(:name, :string, null: false)
    field(:title, :string, null: false)
    field(:status, :string, null: false)
    field(:distance, :float, virtual: true)

    belongs_to(:token_created, Tokens, foreign_key: :token_created_id, type: :binary_id)
    belongs_to(:tokens_asigned, Tokens, foreign_key: :token_asigned_id, type: :binary_id)
    belongs_to(:pickup_locations, PickupLocations, foreign_key: :pickup_location_id, type: :binary_id)
    belongs_to(:delivery_locations, DeliveryLocations, foreign_key: :delivery_location_id, type: :binary_id)

    timestamps()
  end

  @spec changeset(task_fields, attrs) :: result when
    task_fields: t(),
    attrs: map(),
    result: Ecto.Changeset.t()

  def changeset(task_fields, attrs) do
    task_fields
    |> cast(attrs, [:name, :title, :status])
    |> validate_required([:name, :title, :status])
  end
end
