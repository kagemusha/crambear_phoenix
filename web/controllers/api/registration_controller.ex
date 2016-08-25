defmodule CrambearPhoenix.Api.RegistrationController do
  use CrambearPhoenix.Web, :controller

  alias Sentinel.UserRegistration
  alias Sentinel.Util
  alias Sentinel.UserHelper
  alias CrambearPhoenix.User

  def create(conn, params) do
    user_params = Map.get(params, "user")
    changeset = User.registration_changeset(%User{}, user_params)
    #test if pw and pw_confirm the same
    case Repo.insert(changeset) do
      {:ok, user} ->
        permissions = UserHelper.model.permissions(user.role)
        case Guardian.encode_and_sign(user, :token, permissions) do
          { :ok, token, _encoded_claims } ->
            user_data = JaSerializer.format(CrambearPhoenix.Api.UserView, user, conn, %{})
            json conn, %{token: token, user: user_data}
          { :error, :token_storage_failure } -> Util.send_error(conn, %{error: "failed to store session, please try to login again using your new password"})
          { :error, reason } -> Util.send_error(conn, %{error: reason})
        end
      {:error, changeset} -> Util.send_error(conn, changeset.errors)
    end
  end

  def create(_conn, _req) do
    IO.puts "ERROR bad params in reg controller create"
  end
end