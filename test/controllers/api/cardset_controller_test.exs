defmodule CrambearPhoenix.Api.CardsetControllerTest do
  use CrambearPhoenix.ConnCase

  import CrambearPhoenix.TestHelpers
  alias CrambearPhoenix.Cardset

  @valid_attrs %{"name" => "My Cardset"}
  @invalid_attrs %{}

  @blank_name_error %{"detail" => "Name can't be blank", "source" => %{"pointer" => "/data/attributes/name"},
                          "title" => "can't be blank"}

  setup do
    conn = build_conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  test "gets all cardsets", %{conn: conn} do
    test_attrs = %{"name" => "Elixir", "card_count" => 0}

    Repo.insert Map.merge(%Cardset{}, to_atom_params(test_attrs))
    conn = get conn, cardset_path(conn, :index)
    attributes = List.first(json_response(conn, 200)["data"])["attributes"]
    Enum.each(Map.keys(test_attrs), fn(key) ->
      mod_key = String.replace(key, "_", "-")
      assert attributes[mod_key] == test_attrs[key]
    end)
  end

  test "shows chosen resource", %{conn: conn} do
    {user, conn} = login conn
    cardset = insert_cardset(user)
              |> insert_cards(2)
              |> Repo.preload(:cards)

    conn = get conn, cardset_path(conn, :show, cardset)
    response = json_response(conn, 200)
    attributes = response["data"]["attributes"]
    assert match?(%{"name" => "Elixir", "card-count" => 0}, attributes)
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    {user, conn} = login conn
    name = "My Cardset"

    conn =  post conn, cardset_path(conn, :create), build_params(name)
    cardset = List.first(Repo.all from set in Cardset, where: [name: ^name], preload: :user)
    assert cardset.user == user
    attributes = json_response(conn, 201)["data"]["attributes"]
    Enum.each(Map.keys(@valid_attrs), fn(key) ->
      mod_key = String.replace(key, "_", "-")
      assert attributes[mod_key] == @valid_attrs[key]
    end)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    {_, conn} = login conn
    conn = post conn, cardset_path(conn, :create), build_params("")

    assert json_response(conn, 422)["errors"] == [@blank_name_error]
  end

  test "delete cardset", %{conn: conn} do
    {user, conn} = login conn
    cardset = insert_cardset(user)
    assert Repo.get(Cardset, cardset.id)
    conn = delete conn, cardset_path(conn, :delete, cardset)
    assert response(conn, 204)
    refute Repo.get(Cardset, cardset.id)
  end

  test "can't delete someone else's cardset", %{conn: conn} do
    user = insert_user("other@t.com", "tester")
    cardset = insert_cardset(user)

    {_, conn} = login conn
    conn = delete conn, cardset_path(conn, :delete, cardset)

    assert response(conn, :not_found)
    assert Repo.get(Cardset, cardset.id)
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    {user, conn} = login conn
    cardset = insert_cardset(user)

    new_name = "New Name"
    conn = put conn, cardset_path(conn, :update, cardset), build_params(new_name, cardset.id)

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cardset, name: new_name)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    {user, conn} = login conn
    cardset = insert_cardset(user)
    conn = put conn, cardset_path(conn, :update, cardset), build_params("", cardset.id)

    assert json_response(conn, 422)["errors"] == [@blank_name_error]
  end


  defp build_params(name, id \\ nil) do
    data = %{
      "type" => "cardset",
      "attributes" => %{"name" => name},
    }
    data = case id do
      nil -> data
      _ -> Map.put(data, "id", id)
    end
    %{"data" => data}
  end

end
