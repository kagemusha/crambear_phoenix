defmodule CrambearPhoenix.Api.UserController do
  use Phoenix.Controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.EnsureAuthenticated, handler: Application.get_env(:sentinel, :auth_handler) || Sentinel.AuthHandler
  plug Guardian.Plug.LoadResource

  @doc """
  Get the account data for the current user
  Responds with status 200 and body view show JSON
  """
  def show(conn, _params, current_user, _claims) do
    user_data = JaSerializer.format(CrambearPhoenix.Api.UserView, current_user, conn, %{})
    json conn, %{user: user_data}
  end


end
