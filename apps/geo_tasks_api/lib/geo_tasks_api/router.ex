defmodule GeoTasksApi.Router do
  use GeoTasksApi, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GeoTasksApi do
    pipe_through :api
  end
end
