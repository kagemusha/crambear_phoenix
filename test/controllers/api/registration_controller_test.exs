defmodule CrambearPhoenix.Api.RegistrationControllerTest do
  use CrambearPhoenix.ConnCase
  alias CrambearPhoenix.User

  @password "pw12345"
  @valid_attrs %{
    "email" => "mike@example.com",
    "password" => @password,
    "password_confirmation" => @password,
  }

  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, registration_path(conn, :create), %{"user":  @valid_attrs}
    assert conn.status == 200
    assert Repo.get_by(User, %{email: @valid_attrs["email"]})
  end

  test "does not create resource and renders errors when missing fields", %{conn: conn} do
    assert_error_sent 422, fn ->
      conn = post conn, registration_path(conn, :create), %{"user":  @invalid_attrs}
    end
  end

  test "does not create resource when no password", %{conn: conn} do
    assert_error_sent 422, fn ->
      conn = post conn, registration_path(conn, :create), %{"user":  %{"email": "m@m.com"}}
    end
  end
end