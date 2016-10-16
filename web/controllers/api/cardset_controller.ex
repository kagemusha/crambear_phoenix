defmodule CrambearPhoenix.Api.CardsetController do
  use CrambearPhoenix.Web, :controller
  use Guardian.Phoenix.Controller

  alias CrambearPhoenix.Cardset
  alias JaSerializer.Params

  plug Guardian.Plug.LoadResource
  plug :load_and_authorize_resource, model: Cardset, except: [:index]

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params, _current_user, _token) do
    cardsets = Repo.all(Cardset)
    render(conn, "index.json-api", data: cardsets)
  end

  def create(conn, %{"data" => %{"attributes" => cardset_params}}, current_user, _token) do
    changeset = Cardset.create_changeset(%Cardset{}, current_user, cardset_params)
    case Repo.insert(changeset) do
      {:ok, cardset} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def show(conn, _cardset, _current_user, _token) do
    case conn.assigns.cardset do
      nil ->
        send_resp(conn, :not_found, "")
      cardset ->
        cardset = Repo.preload(cardset, :cards)
        render(conn, data: cardset)
    end
  end

  def update(conn, %{"data" => data = %{"id"=> id, "attributes" => _cardset_params}}, current_user, token) do
    cardset = Repo.get!(Cardset, id)
    changeset = Cardset.changeset(cardset, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, cardset} ->
        render(conn, "show.json-api", data: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, _cardset, _current_user, _token) do
    case conn.assigns.cardset do
      nil ->
        send_resp(conn, :not_found, "")
      cardset ->
        Repo.delete!(cardset)
        send_resp(conn, :no_content, "")
    end
  end

end
