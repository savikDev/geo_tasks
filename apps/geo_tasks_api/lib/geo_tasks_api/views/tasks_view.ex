defmodule GeoTasksApi.TasksView do
  @moduledoc false

  use GeoTasksApi, :view

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end

  def render("get_open_tasks.json", %{tasks: tasks}) do
    render_many(tasks, __MODULE__, "task.json")
  end

  def render("task.json", %{tasks: task}) do
    %{
      id: task.id,
      name: task.name,
      title: task.title,
      pickup_location: task.pickup_locations,
      delivery_location: task.delivery_locations,
      distance: task.distance
    }
  end
end
