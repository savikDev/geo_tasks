defmodule GeoTasksDb.DeliveryLocationsQueries do
  @moduledoc """
    Database queries for delivery location
  """

  alias GeoTasksDb.DeliveryLocations, as: DeliveryLocationsSchema
  alias GeoTasksDb.Repo
  alias Ecto.Changeset

  @doc """
    Add new pickup location
  """
  @spec add_new_delivery_location(location) :: result when
          location: {number(), number()},
          result: {:ok, DeliveryLocationsSchema.t()} | {:error, Ecto.Changeset.t()}
  def add_new_delivery_location({lng, lat}) do
    location =  %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    %DeliveryLocationsSchema{}
    |> DeliveryLocationsSchema.changeset(%{location: location})
    |> Repo.insert()
  end

  @doc """
    Update pickup location
  """
  @spec update_delivery_location(params) :: result when
          params: map(),
          result: {:ok, DeliveryLocationsSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_delivery_location(%{id: id, location: {lng, lat}}) do
    location =  %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    DeliveryLocationsSchema
    |> Repo.get!(id)
    |> Changeset.change(location: location)
    |> Repo.update
  end

end
