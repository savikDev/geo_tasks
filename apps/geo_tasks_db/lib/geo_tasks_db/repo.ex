defmodule GeoTasksDb.Repo do
  use Ecto.Repo, otp_app: :geo_tasks_db, adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  @spec init(args, opts) :: result when
    args: :supervisor | :runtime,
    opts: Keyword.t(),
    result: {:ok, Keyword.t()} | :ignore
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
