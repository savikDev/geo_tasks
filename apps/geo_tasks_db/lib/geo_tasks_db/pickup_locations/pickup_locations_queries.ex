defmodule GeoTasksDb.PickupLocationsQueries do
  @moduledoc """
    Database queries for pickup location
  """

  alias GeoTasksDb.PickupLocations, as: PickupLocationsSchema
  alias GeoTasksDb.Repo
  alias Ecto.Changeset

  import Ecto.Query

  @doc """
    Add new pickup location
  """
  @spec add_new_pickup_location(params) :: result when
    params: {number(), number()},
    result: {:ok, PickupLocationsSchema.t()} | {:error, Ecto.Changeset.t()}
  def add_new_pickup_location({lng, lat}) do
    location =  %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    %PickupLocationsSchema{}
    |> PickupLocationsSchema.changeset(%{location: location})
    |> Repo.insert()
  end

  @doc """
    Update pickup location
  """
  @spec update_pickup_location(params) :: result when
    params: map(),
    result: {:ok, PickupLocationsSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_pickup_location(%{id: id, location: {lat, lng}}) do
    location =  %Geo.Point{coordinates: {lng, lat}, srid: 4326}
    %PickupLocationsSchema{}
    |> Repo.get!(id)
    |> Changeset.change(location: location)
    |> Repo.update
  end
end
