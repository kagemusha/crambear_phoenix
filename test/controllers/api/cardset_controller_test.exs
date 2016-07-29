defmodule CrambearPhoenix.Api.CardsetControllerTest do
  use CrambearPhoenix.ConnCase

  alias CrambearPhoenix.Cardset
  alias CrambearPhoenix.Repo

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, cardset_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = get conn, cardset_path(conn, :show, cardset)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{cardset.id}"
    assert data["type"] == "cardset"
    assert data["attributes"]["name"] == cardset.name
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, cardset_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, cardset_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "cardset",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Cardset, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, cardset_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "cardset",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = put conn, cardset_path(conn, :update, cardset), %{
      "meta" => %{},
      "data" => %{
        "type" => "cardset",
        "id" => cardset.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Cardset, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = put conn, cardset_path(conn, :update, cardset), %{
      "meta" => %{},
      "data" => %{
        "type" => "cardset",
        "id" => cardset.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    cardset = Repo.insert! %Cardset{}
    conn = delete conn, cardset_path(conn, :delete, cardset)
    assert response(conn, 204)
    refute Repo.get(Cardset, cardset.id)
  end

end
