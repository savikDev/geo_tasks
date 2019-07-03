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
    result: {integer(), nil | [term()]}
  def delete_role(role_id) do
    Repo.transaction fn ->
      %RolesSchema{}
      |> Repo.get(role_id)
      |> Repo.delete()
      |> case do
           {:ok, record} ->
             record
           {:error, changeset} ->
             error = "INCORRECT_REQUEST"
             Repo.rollback(error)
         end
    end
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
