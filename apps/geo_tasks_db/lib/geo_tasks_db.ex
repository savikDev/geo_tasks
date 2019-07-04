defmodule GeoTasksDb do
  @moduledoc """
  GeoTasksDb keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias GeoTasksDb.RolesQueries
  alias GeoTasksDb.TokensQueries
  alias GeoTasksDb.TasksQueries
  alias GeoTasksDb.DeliveryLocationsQueries
  alias GeoTasksDb.PickupLocationsQueries

  alias GeoTasksDb.Roles
  alias GeoTasksDb.Tokens
  alias GeoTasksDb.Tasks
  alias GeoTasksDb.PickupLocations
  alias GeoTasksDb.DeliveryLocations

  @doc """
    Create new role
  """
  @spec create_new_role(name) :: result when
          name: %{name: String.t()},
          result: {:ok, Roles.t()} | {:error, Ecto.Changeset.t()}
  def create_new_role(name) do
    name
    |> RolesQueries.add_role()
  end

  @doc """
    Create new token
  """
  @spec create_new_token(name) :: result when
          name: %{role_name: String.t()},
          result: {:ok, Tokens.t()} | {:error, Ecto.Changeset.t()}
  def create_new_token(params) do
    params
    |> TokensQueries.create_new_token()
  end

  @doc """
    Activate token on the id
  """
  @spec activate_token(token_id) :: result when
          token_id: String.t(),
          result: {:ok, Tokens.t()} | {:error, Ecto.Changeset.t()}
  def activate_token(token_id) do
    token_id
    |> TokensQueries.activate_token()
  end

  @doc """
    Deactivate token on the id
  """
  @spec deactivate_token(token_id) :: result when
          token_id: String.t(),
          result: {:ok, Tokens.t()} | {:error, Ecto.Changeset.t()}
  def deactivate_token(token_id) do
    token_id
    |> TokensQueries.deactivate_token()
  end

  @doc """
    Create new pickup location
  """
  @spec create_new_pickup_location(location) :: result when
          location: {number(), number()},
          result: {:ok, PickupLocations.t()} | {:error, Ecto.Changeset.t()}
  def create_new_pickup_location({_, _} = location) do
    location
    |> PickupLocationsQueries.add_new_pickup_location()
  end

  @doc """
    Update pickup location
  """
  @spec update_pickup_location(params) :: result when
          params: map(),
          result: {:ok, PickupLocations.t()} | {:error, Ecto.Changeset.t()}
  def update_pickup_location(params) do
    params
    |> PickupLocationsQueries.update_pickup_location()
  end

  @doc """
    Create new delivery location
  """
  @spec create_new_delivery_location(location) :: result when
          location: {number(), number()},
          result: {:ok, DeliveryLocations.t()} | {:error, Ecto.Changeset.t()}
  def create_new_delivery_location({_, _} = location) do
    location
    |> DeliveryLocationsQueries.add_new_delivery_location()
  end

  @doc """
    Update delivery location
  """
  @spec update_delivery_location(params) :: result when
          params: map(),
          result: {:ok, DeliveryLocations.t()} | {:error, Ecto.Changeset.t()}
  def update_delivery_location(params) do
    params
    |> DeliveryLocationsQueries.update_delivery_location()
  end

  @doc """
    Create new task
  """
  @spec create_new_task(params) :: result when
          params: map(),
          result: {:ok, Tasks.t()} | {:error, Ecto.Changeset.t()}
  def create_new_task(params) do
    params
    |> TasksQueries.create_new_task("CREATED")
  end

  @doc """
    Select open tasks
  """
  @spec select_open_tasks(location, distance) :: result when
          location: {number(), number()},
          distance: number(),
          result: {:ok, [Tasks.t()]} | {:error, Ecto.Changeset.t()}
  def select_open_tasks(location, distance) do
      location
      |> TasksQueries.select_open_tasks(distance)
  end

  @doc """
    Change task status on "DELIVERED"
  """
  @spec update_task_assigned_status(task_id, token) :: result when
          task_id: String.t(),
          token: String.t(),
          result: {:ok, Tasks.t()} | {:error, Ecto.Changeset.t()}
  def update_task_assigned_status(task_id, token) do
    task_id
    |> TasksQueries.update_task_status(token, "ASSIGNED")
  end

  @doc """
    Change task status on "COMPLETED"
  """
  @spec update_task_done_status(task_id) :: result when
          task_id: String.t(),
          result: {:ok, Tasks.t()} | {:error, Ecto.Changeset.t()}
  def update_task_done_status(task_id) do
    task_id
    |> TasksQueries.update_task_status("DONE")
  end

  @doc """
    Get token infp
  """
  @spec get_token(token) :: result when
          token: String.t(),
          result: Tokens.t() | nil
  def get_token(token) do
    token
    |> TokensQueries.get_token()
  end

end
