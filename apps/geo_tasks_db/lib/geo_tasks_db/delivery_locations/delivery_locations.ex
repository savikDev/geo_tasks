defmodule GeoTasksDb.DeliveryLocations do
  @moduledoc """
    Delivery_locations schema description
  """
  use Ecto.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
                id: String.t() | nil,
                location: %Geo.Point{} | nil,
                inserted_at: NaiveDateTime.t()| nil,
                updated_at: NaiveDateTime.t() | nil
             }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "delivery_locations" do
    field :location, Geo.PostGIS.Geometry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(delivery_locations_fields, attrs) :: result when
          delivery_locations_fields: t(),
          attrs: map(),
          result: Ecto.Changeset.t()
  def changeset(delivery_locations_fields, attrs) do
    delivery_locations_fields
    |> cast(attrs, [:location])
    |> validate_required([:location])
  end

end