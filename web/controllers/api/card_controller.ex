defmodule CrambearPhoenix.Api.CardController do
  use CrambearPhoenix.Web, :controller
  use Guardian.Phoenix.Controller

  alias CrambearPhoenix.Card
  alias JaSerializer.Params

  plug Guardian.Plug.LoadResource
  plug :load_and_authorize_resource, model: Card
  plug :scrub_params, "data" when action in [:create, :update]

#  def index(conn, _params) do
#    cards = Repo.all(Card)
#    render(conn, "index.json-api", data: cards)
#  end

  def create(conn, %{"data" => %{"attributes" => card_params}}, current_user, _token) do
    case Card.create(card_params)  do
      {:ok, card} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", card_path(conn, :show, card))
        |> render("show.json-api", data: card)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    card = Repo.get!(Card, id)
    render(conn, "show.json-api", data: card)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "card", "attributes" => _card_params}}) do
    card = Repo.get!(Card, id)
    changeset = Card.changeset(card, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, card} ->
        render(conn, "show.json-api", data: card)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    card = Repo.get!(Card, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(card)

    send_resp(conn, :no_content, "")
  end

end
