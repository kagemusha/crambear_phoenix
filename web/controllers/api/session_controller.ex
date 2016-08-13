defmodule CrambearPhoenix.Api.SessionController do
  use Phoenix.Controller

  alias Sentinel.Authenticator
  alias Sentinel.UserHelper
  alias Sentinel.Util

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated, %{ handler: Application.get_env(:sentinel, :auth_handler) || Sentinel.AuthHandler } when action in [:delete, :show]

  @doc """
  Log in as an existing user.
  Parameter are "email" and "password".
  Responds with status 200 and {token: token} if credentials were correct.
  Responds with status 401 and {errors: error_message} otherwise.
  """
  def create(conn, %{"username" => username, "password" => password}) do
    auth(conn, :authenticate_by_username, username, password)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    auth(conn, :authenticate_by_email, email, password)
  end

  defp auth(conn, auth_fn, id, password) do
    case apply(Authenticator, auth_fn, [id, password]) do
      {:ok, user} ->
        permissions = UserHelper.model.permissions(user.role)

        case Guardian.encode_and_sign(user, :token, permissions) do
          { :ok, token, _encoded_claims } ->
            user_data = JaSerializer.format(CrambearPhoenix.Api.UserView, user, conn, %{})
            json conn, %{token: token, user: user_data}
          { :error, :token_storage_failure } -> Util.send_error(conn, %{error: "failed to store session, please try to login again using your new password"})
          { :error, reason } -> Util.send_error(conn, %{error: reason})
        end
      {:error, errors} ->
        Util.send_error(conn, errors, 401)
    end
  end

  @doc """
  Destroy the active session.
  Will delete the authentication token from the user table.
  Responds with status 200 if no error occured.
  """
  def delete(conn, _params) do
    token = Plug.Conn.get_req_header(conn, "authorization") |> List.first

    case Guardian.revoke! token do
      :ok -> send_resp conn, 204, ""
      { :error, :could_not_revoke_token } -> Util.send_error(conn, %{error: "Could not revoke the session token"}, 422)
      { :error, error } -> Util.send_error(conn, error, 422)
    end
  end
end
