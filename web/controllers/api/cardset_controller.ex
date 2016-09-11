defmodule CrambearPhoenix.Api.CardsetController do
  use CrambearPhoenix.Web, :controller
  use Guardian.Phoenix.Controller

  alias CrambearPhoenix.Cardset
  alias JaSerializer.Params

  plug Guardian.Plug.LoadResource


  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params, _current_user, _token) do
    cardsets = Repo.all(Cardset)
    render(conn, "index.json-api", data: cardsets)
  end

  def create(conn, %{"data" => %{"attributes" => cardset_params}}, current_user, _token) do
    changeset = Ecto.build_assoc(current_user, :cardsets, to_atom_params(cardset_params))
    case Repo.insert(changeset) do
      {:ok, cardset} ->
        conn
        |> put_status(:created)
        |> render("show.json-api", data: cardset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(CrambearPhoenix.ChangesetView, "error.json-api", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    cardset = Repo.get!(Cardset, id)
              |> Repo.preload(:cards)

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

  def delete(conn, %{"id" => id}, _current_user, _token) do
    cardset = Repo.get!(Cardset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(cardset)

    send_resp(conn, :no_content, "")
  end

end
