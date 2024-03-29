defmodule GeoTasksApi.TasksController do
  @moduledoc false
  use GeoTasksApi, :controller

  alias GeoTasksDb

  @typep conn()           :: Plug.Conn.t()
  @typep result()         :: Plug.Conn.t()
  @typep name()           :: String.t()
  @typep title()          :: String.t()
  @typep token_id()       :: String.t()
  @typep lng()            :: number()
  @typep lat()            :: number()
  @typep location()       :: %{lng: lng(), lat: lat()}

  @typep create_task_params() :: %{name: name(),
                                   title: title(),
                                   pickup_location: location(),
                                   delivery_location: location(),
                                   token_id: token_id()}

  @spec create(conn, create_params) :: result when
          conn: conn(),
          create_params: create_task_params(),
          result: result()
  def create(conn, %{pickup_location: %{lng: p_lng, lat: p_lat},
    delivery_location: %{lng: d_lng, lat: d_lat}} = create_params) do
    with {:ok, token} <- check_header(conn, "Manager"),
         task_info <- Map.merge(create_params, %{pickup_location: {p_lng, p_lat},
                                                    delivery_location: {d_lng, d_lat}}),
         {:ok, _} <- GeoTasksDb.create_new_task(Map.put(task_info, :token, token)) do
      render(conn, "create.json", %{status: "success"})
    end
  end

  @spec get_open_tasks(conn, params) :: result when
          conn: conn(),
          params: %{lng: lng(), lat: lat(), distance: number()},
          result: result()
  def get_open_tasks(conn, %{lng: lng, lat: lat, distance: distance}) do
    with {:ok, token} <- check_header(conn, "Driver"),
         {:ok, tasks} <- GeoTasksDb.select_open_tasks({lng, lat}, distance)
      do
      task_with_updated_coordinates =
        Enum.map(tasks, fn(task) -> update_coordinates(task) end)
      render(conn, "get_open_tasks.json", %{tasks: task_with_updated_coordinates})
    end
  end

  @spec assigned_task(conn, params) :: result when
          params: map(),
          conn: conn(),
          result: result()
  def assigned_task(conn, %{id: id}) do

    with  {:ok, token} <- check_header(conn, "Driver"),
          {:ok, task} <- GeoTasksDb.update_task_assigned_status(id, token)
      do
      render(conn, "task_status.json", task)
    end
  end

  @spec done_task(conn, params) :: result when
          conn: conn(),
          params: map(),
          result: result()
  def done_task( conn, %{id: id}) do
    with  {:ok, token} <- check_header(conn, "Driver"),
          {:ok, task} <- GeoTasksDb.update_task_done_status(id)
      do
      render(conn, "task_status.json", task)
    end
  end

  @spec update_coordinates(task) :: result when
          task: map(),
          result: map()
  defp update_coordinates(task) do
    {p_lng, p_lat} = task.pickup_locations.location.coordinates
    {d_lng, d_lat} = task.pickup_locations.location.coordinates
    Map.merge(task, %{pickup_locations: %{lng: p_lng, lat: p_lat},
      delivery_locations: %{lng: d_lng, lat: d_lat}})
  end

  @spec check_header(conn, role) :: result when
          conn: conn(),
          role: String.t(),
          result: {:ok, String.t()} | {:error, String.t()}
  defp check_header(conn, role) do
    with [h_role] <- get_req_header(conn, "user_role"),
         true <- h_role == role,
         [token] <- get_req_header(conn,  "authorization_token") do
        {:ok, token}
      else
        _ -> {:error, "INCORRECT_ROLE"}
    end
  end
end
