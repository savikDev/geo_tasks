defmodule GeoTasksApi.Plugs.Headers do
  @moduledoc """
  Plug.Conn helpers
  """
  use GeoTasksApi, :plugs
  alias GeoTasksDb

  @type dets_authorization_info() :: [{String.t, {String.t, boolean(), String.t, String.t}}]

  @authorization_header_key "authorization_token"

  #  --Error messages--
  @inactive_user    "User is inactive or deleted"
  @missing_header   "Missing header authorization"

  @spec required_headers(Plug.Conn.t(), any()) :: Plug.Conn.t() | no_return()
  def required_headers(conn, _) do
    get_req_header(conn,  @authorization_header_key)
    |> select_authorization_params(conn)
  end

  @spec select_authorization_params(list(), Plug.Conn.t()) :: Plug.Conn.t() | no_return()
  defp select_authorization_params([], conn), do: response_error(conn, @missing_header)
  defp select_authorization_params([authorization], conn), do: check_authorization_params(authorization, conn)
  defp select_authorization_params(_, conn), do: response_error(conn, @missing_header)

  @spec check_authorization_params(String.t(), Plug.Conn.t()) :: Plug.Conn.t() | no_return()
  def check_authorization_params(token, conn) do
    token
    |> GeoTasksDb.get_token()
    |> check_token_and_status(conn)
  end

  @spec check_token_and_status(map() | nil, Plug.Conn.t()) :: Plug.Conn.t() | no_return()
  defp check_token_and_status(%{token: _token, active: true, roles: %{name: name}}, conn)
    do
    put_req_header(conn, "user_role", name)
  end
  defp check_token_and_status(_, _, conn), do: response_error(conn, @inactive_user)

  @spec response_error(Plug.Conn.t(), String.t()) ::  no_return()
  defp response_error(conn, error_message) do
    send_resp(conn, 401, Jason.encode!(%{errors: %{detail: error_message}}))
    |> halt()
  end
end
