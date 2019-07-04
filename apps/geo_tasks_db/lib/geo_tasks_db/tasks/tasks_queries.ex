defmodule GeoTasksDb.TasksQueries do
  @moduledoc """
    Database queries for user tokens
  """

  alias GeoTasksDb.Tasks, as: TasksSchema
  alias GeoTasksDb.TokensQueries, as: TokensQueries
  alias GeoTasksDb.DeliveryLocationsQueries
  alias GeoTasksDb.PickupLocationsQueries

  alias GeoTasksDb.Repo
  alias Ecto.Changeset

  import Ecto.Query

  @doc """
    Create new task
  """
  @spec create_new_task(params, status) :: result when
          params: map(),
          status: String.t,
          result: {:ok, TasksSchema.t()} | {:error, Ecto.Changeset.t()}
  def create_new_task(%{pickup_location: pickup_location,
    delivery_location: delivery_location, token: token} = params, status) do
    Repo.transaction fn ->
      {:ok, delivery_location_point} =
        DeliveryLocationsQueries.add_new_delivery_location(delivery_location)
      {:ok, pickup_location_point}  =
        PickupLocationsQueries.add_new_pickup_location(pickup_location)

      token = TokensQueries.get_token(token)

      %TasksSchema{name: params.name, title: params.title, status: status}
      |> TasksSchema.changeset(%{})
      |> Changeset.put_assoc(:pickup_locations, pickup_location_point)
      |> Changeset.put_assoc(:delivery_locations, delivery_location_point)
      |> Changeset.put_assoc(:token_created, token)
      |> Repo.insert()
      |> check_result_with_rollback()
    end
  end

  @spec check_result_with_rollback(query_res) :: result when
          query_res: {:ok, TasksSchema.t()} | {:error, String.t()},
          result: {:ok, TasksSchema.t()} | {:error, map()}
  defp check_result_with_rollback({:ok, record}), do: record
  defp check_result_with_rollback({:error, _}) do
    {:error, "INCORRECT_REQUEST"}
    |> Repo.rollback()
  end

  @doc """
    Select all tasks with status 'CREATED'
  """
  @spec select_open_tasks(point, distance) :: result when
          point: {number(), number()},
          distance: number(),
          result: {:ok, [TasksSchema.t()]} |  {:error, String.t()}
  def select_open_tasks({lng, lat}, distance) do
    res =
      %Geo.Point{coordinates: {lng, lat}, srid: 4326}
      |> select_tasks_query(distance)
      |> Repo.all
    {:ok, res}
  end

  @doc """
    Update task`s status
  """
  @spec update_task_status(task_id, token, status) :: result when
          task_id: String.t(),
          token: String.t(),
          status: String.t(),
          result: {:ok, TasksSchema.t()} |  {:error, String.t()}
  def update_task_status(task_id, token, status) do
    token = TokensQueries.get_token(token)

    TasksSchema
    |> Repo.get!(task_id)
    |> Changeset.change(status: status, token_asigned_id: token.id)
    |> Repo.update
  end

  @doc """
    Update task`s status
  """
  @spec update_task_status(task_id, status) :: result when
          task_id: String.t(),
          status: String.t(),
          result: {:ok, TasksSchema.t()} |  {:error, String.t()}
  def update_task_status(task_id, status) do
    TasksSchema
    |> Repo.get!(task_id)
    |> Changeset.change(status: status)
    |> Repo.update
  end

#  ------ help functions -----

  @spec select_tasks_query(point, radius_in_m) :: result when
          point: %Geo.Point{},
          radius_in_m: float(),
          result: %Ecto.Query{}
  defp select_tasks_query(%{coordinates: {lng, lat}, srid: srid}, radius_in_m) do
    from(tasks in TasksSchema,
      left_join: pickup_locations in assoc(tasks, :pickup_locations),
      left_join: delivery_locations in assoc(tasks, :delivery_locations),
      preload: [pickup_locations: pickup_locations,
        delivery_locations: delivery_locations],
      where: tasks.status == "CREATED" and
             fragment("ST_DWithin(?::geography, ST_SetSRID(ST_MakePoint(?, ?), ?), ?)",
               pickup_locations.location, ^lng, ^lat, ^srid, ^radius_in_m),
      order_by: fragment("? <-> ST_SetSRID(ST_MakePoint(?,?), ?)",
        pickup_locations.location, ^lng, ^lat, ^srid),
      select: %{tasks | distance:
      fragment("ST_Distance_Sphere(?, ST_SetSRID(ST_MakePoint(?,?), ?))",
        pickup_locations.location, ^lng, ^lat, ^srid)})
  end

end
