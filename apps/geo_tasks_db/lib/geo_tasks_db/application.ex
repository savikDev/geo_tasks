defmodule GeoTasksDb.Application do
  @moduledoc """
  The GeoTasksDb Application Service.

  The geo_tasks_db system business domain lives in this application.

  Exposes API to clients such as the `GeoTasksDbWeb` application
  for use in channels, controllers, and elsewhere.
  """
  use Application

  @spec start(type, args) :: result when
    type: atom(),
    args: :permanent | :transient | :temporary,
    result: {:ok, pid()} | {:ok, pid(), any()} | {:error, term()}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    Supervisor.start_link([
      supervisor(GeoTasksDb.Repo, []),
    ], strategy: :one_for_one, name: GeoTasksDb.Supervisor)
  end
end
