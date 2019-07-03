defmodule GeoTasksDb.PickupLocations do
  @moduledoc """
    Pickup_locations schema description
  """
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}

  @type t :: %__MODULE__{
               id: String.t() | nil,
               location: %Geo.Point{} | nil,
               inserted_at: NaiveDateTime.t()| nil,
               updated_at: NaiveDateTime.t() | nil
             }

  schema "pickup_locations" do
    field :location, Geo.PostGIS.Geometry

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(pickup_locations_fields, attrs) :: result when
          pickup_locations_fields: t(),
          attrs: map(),
          result: Ecto.Changeset.t()
  def changeset(pickup_locations_fields, attrs \\ %{}) do
    pickup_locations_fields
    |> cast(attrs, [:location])
    |> validate_required([:location])
  end


end
