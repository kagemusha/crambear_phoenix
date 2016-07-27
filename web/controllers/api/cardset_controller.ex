defmodule CrambearPhoenix.Api.CardsetController do
  use CrambearPhoenix.Web, :controller

  alias CrambearPhoenix.Cardset

  plug :scrub_params, "cardset" when action in [:create, :update]

  def index(conn, _params) do
    cardsets = Repo.all(Cardset)
    render(conn, "index.json", cardsets: cardsets)
  end

  def create(conn, %{"cardset" => cardset_params}) do
    changeset = Cardset.changeset(%Cardset{}, cardset_params)

    case Repo.insert(changeset) do
      {:ok, cardset} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", cardset_path(conn, :show, cardset))
        |> render("show.json", cardset: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cardset = Repo.get!(Cardset, id)
    render(conn, "show.json", cardset: cardset)
  end

  def update(conn, %{"id" => id, "cardset" => cardset_params}) do
    cardset = Repo.get!(Cardset, id)
    changeset = Cardset.changeset(cardset, cardset_params)

    case Repo.update(changeset) do
      {:ok, cardset} ->
        render(conn, "show.json", cardset: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json", changeset: changeset)
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
