defmodule Json.UserControllerTest do
  use CrambearPhoenix.ConnCase
  alias CrambearPhoenix.User

  @email "user@example.com"
  @password "secret"
  @headers [{"content-type", "application/json"}]
  @role "user"


  test "authenticate with token" do
    user = Repo.insert!(%User{
      email: "user@example.com",
      hashed_password: Sentinel.Util.crypto_provider.hashpwsalt("password")
    })
    permissions = User.permissions(user.role)
    assert length(Repo.all(GuardianDb.Token)) == 0

    { :ok, token, _} = Guardian.encode_and_sign(user, :token, permissions)
    assert length(Repo.all(GuardianDb.Token)) == 1

    conn = build_conn()
            |> put_req_header("authorization", "Bearer #{token}")
            |> get("/api/me")
    %{"user"=> %{"data" => %{"attributes"=> %{"email"=> email}}}} = Poison.decode!(conn.resp_body)
    assert conn.status == 200
    assert email == @email
  end
end
