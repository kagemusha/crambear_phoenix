defmodule Json.SessionControllerTest do
  use CrambearPhoenix.ConnCase
  alias Sentinel.Registrator
  alias CrambearPhoenix.User

  @email "user@example.com"
  @username "user@example.com"
  @password "secret"
  @headers [{"content-type", "application/json"}]
  @role "user"

  test "sign in with unknown email" do
    conn = post(build_conn(), "/api/sessions", %{password: @password, email: @email})
    assert conn.status == 401
    assert conn.resp_body == Poison.encode!(%{errors: [%{base: "Unknown email or password"}]})
  end

  test "login works" do
    Registrator.changeset(%{"email" => @email, "password" => @password, "role" => "user"})
                                      |> Ecto.Changeset.put_change(:confirmed_at, Ecto.DateTime.utc)
                                      |> Repo.insert!

    conn = post(build_conn(), "/api/sessions", %{email: @email, password: @password})
    assert conn.status == 200
    %{"token" => token, "user" => %{"data" => %{"attributes"=> %{"email" => email}}}} = Poison.decode!(conn.resp_body)
    stored_token = Repo.get_by!(GuardianDb.Token, jwt: token)
    assert token == stored_token.jwt
    assert email == @email
  end

  test "sign out" do
    user = Repo.insert!(%User{
      email: "signout@example.com",
      hashed_password: Sentinel.Util.crypto_provider.hashpwsalt("password")
    })
    permissions = User.permissions(user.role)
    assert length(Repo.all(GuardianDb.Token)) == 0

    { :ok, token, _} = Guardian.encode_and_sign(user, :token, permissions)
    assert length(Repo.all(GuardianDb.Token)) == 1

    conn = build_conn()
            |> put_req_header("authorization", "Bearer #{token}")
            |> delete("/api/sessions")
    assert conn.status == 204
  end
end
