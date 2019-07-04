defmodule GeoTasksDb.TokensQueries do
  @moduledoc """
    Database queries for user tokens
  """

  alias GeoTasksDb.Tokens, as: TokensSchema
  alias GeoTasksDb.Repo
  alias GeoTasksDb.RolesQueries
  alias Ecto.Changeset
  import Ecto.Query

  @type token_id() :: String.t()
  @doc """
    Create new token
  """
  @spec create_new_token(params) :: result when
    params: %{role_name: String.t()},
    result: {:ok, TokensSchema.t()} | {:error, Ecto.Changeset.t()}
  def create_new_token(%{role_name: role_name}) do
    role =  RolesQueries.select_role(role_name)
    token = generate_token()

    %TokensSchema{token: token}
    |> Changeset.change()
    |> Changeset.put_assoc(:roles, role)
    |> Repo.insert()
  end

  @doc """
    Activate token
  """
  @spec activate_token(params) :: result when
    params: token_id(),
    result: {:ok, TokensSchema.t()} | {:error, Ecto.Changeset.t()}
  def activate_token(token_id), do: change_status(token_id, true)

  @doc """
    Deactivate tokens
  """
  @spec deactivate_token(params) :: result when
    params: token_id(),
    result: {:ok, TokensSchema.t()} | {:error, Ecto.Changeset.t()}
  def deactivate_token(token_id), do: change_status(token_id, false)

  @doc """
    Get token info
  """
  @spec get_token(token) :: result when
          token: String.t(),
          result: TokensSchema.t() | nil
  def get_token(token) do
   query = from(tokens in TokensSchema,
     left_join: roles in assoc(tokens, :roles),
     preload: [roles: roles],
     where: tokens.token == ^token)
   query
   |> Repo.one
  end
#  ------------- Help function ------------------------------------------------

  @spec generate_token :: result when
    result: token_id()
  defp generate_token() do
    key_binary =
      <<
        System.system_time(:nanosecond)::64,
        :erlang.phash2({node(), self()}, 16_777_216)::24,
        :erlang.unique_integer()::32
      >>
    Base.hex_encode32(key_binary, case: :lower)
  end

  @spec change_status(token_id, new_status) :: result when
          token_id: token_id(),
          new_status: boolean(),
          result: {:ok, TokensSchema.t()} | {:error, String.t()}
  defp change_status(token_id, new_status) when is_boolean(new_status) do
    Repo.transaction fn ->
      token_id
      |> select_token()
      |> Changeset.change(active: new_status)
      |> Repo.update()
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

  @spec select_token(token_id) :: result when
          token_id: token_id(),
          result: TokensSchema.t() | :nil
  def select_token(token_id) do
    TokensSchema
    |> Repo.get_by!(id: token_id)
  end


end
