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

  test "doesn't create resource when email or password missing", %{conn: conn} do
    Enum.each(["email","password"], fn(key) -> test_field_missing(conn, key) end)
  end

  test "doesn't create resource when password_confirmation missing", %{conn: conn} do
    additional_errors = [%{"password": "password field doesn't equal password_confirmation field"}]
    test_field_missing conn, "password_confirmation", additional_errors
  end

  defp test_field_missing(conn, field, additional_errors \\ []) do
    attrs = Map.delete(@valid_attrs, field)
    conn = post conn, registration_path(conn, :create), %{"user":  attrs}
    assert conn.status == 422
    errors = additional_errors ++ [ Map.put(%{}, field, "can't be blank") ]
    assert conn.resp_body == Poison.encode!(%{errors: errors})
  end

end