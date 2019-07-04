defmodule GeoTasksApi.Router do
  use GeoTasksApi, :router

  use Plug.ErrorHandler

  import GeoTasksApi.Plugs.Headers

  pipeline :api do
    plug :accepts, ["json"]
    plug :required_headers
  end

  scope "/api", GeoTasksApi do
    pipe_through :api

    scope "/task"  do
      resources "/", TasksController, except: [:new, :update, :show, :delete, :edit, :index]
      post "/assign", TasksController, :assigned_task
      post "/done", TasksController, :done_task
      post "/select", TasksController, :get_open_tasks
    end
  end

  defp handle_errors(%Plug.Conn{status: 500} = conn, _) do
    send_resp(conn, 500, Jason.encode!(%{errors: %{detail: "Internal server error"}}))
  end

  defp handle_errors(_, _), do: nil
end
