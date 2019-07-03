defmodule GeoTasksDb.RolesQueries do
  @moduledoc """
    Database queries for user roles
  """

  alias GeoTasksDb.Roles, as: RolesSchema
  alias GeoTasksDb.Repo

  import Ecto.Query

  @doc """
    Add new role
  """
  @spec add_role(params) :: result when
          params: %{name: String.t()},
          result: {:ok, RolesSchema.t()} | {:error, Ecto.Changeset.t()}
  def add_role(params) do
    %RolesSchema{}
    |> RolesSchema.changeset(params)
    |> Repo.insert()
  end

  @doc """
    Update role name
  """
  @spec update_role_name(params) :: result when
          params: %{id: String.t(), new_name: String.t()},
          result: {:ok, RolesSchema.t()} | {:error, Ecto.Changeset.t()}
  def update_role_name(params) do
    %RolesSchema{}
    |> Repo.get!(params.id)
    |> Ecto.Changeset.change(name: params.new_name)
    |> Repo.update
  end

  @doc """
    Delete role
  """
  @spec delete_role(role_id) :: result when
          role_id: String.t(),
          result: {:ok, RolesSchema.t()} | {:error, map()}
  def delete_role(role_id) do
    Repo.transaction fn ->
      %RolesSchema{}
      |> Repo.get(role_id)
      |> Repo.delete()
      |> check_result_with_rollback()
    end
  end

  @spec check_result_with_rollback(query_res) :: result when
          query_res: {:ok, TokensSchema.t()} | {:error, String.t()},
          result: {:ok, TokensSchema.t()} | {:error, map()}
  defp check_result_with_rollback({:ok, _} = res), do: res
  defp check_result_with_rollback({:error, _}) do
    {:error, "INCORRECT_REQUEST"}
    |> Repo.rollback()
  end

  @doc """
    Select role record on the name
  """
  @spec select_role(name) :: result when
          name: String.t(),
          result: RolesSchema.t() | nil
  def select_role(name) do
    Repo.get_by!(RolesSchema, name: name)
  end

end
