defmodule CrambearPhoenix.Api.CardsetController do
  use CrambearPhoenix.Web, :controller

  alias CrambearPhoenix.Cardset
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    cardset = Repo.all(Cardset)
    render(conn, "index.json-api", data: cardset)
  end

  def create(conn, %{"data" => data = %{"type" => "cardset", "attributes" => _cardset_params}}) do
    changeset = Cardset.changeset(%Cardset{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, cardset} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cardset_path(conn, :show, cardset))
        |> render("show.json-api", data: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cardset = Repo.get!(Cardset, id)
              |> Repo.preload :cards

    render(conn, "show.json-api", data: cardset)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "cardset", "attributes" => _cardset_params}}) do
    cardset = Repo.get!(Cardset, id)
    changeset = Cardset.changeset(cardset, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, cardset} ->
        render(conn, "show.json-api", data: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    cardset = Repo.get!(Cardset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cardset)

    send_resp(conn, :no_content, "")
  end

end
