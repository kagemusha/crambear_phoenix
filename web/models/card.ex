defmodule CrambearPhoenix.Card do
  use CrambearPhoenix.Web, :model
  alias CrambearPhoenix.Cardset
  alias CrambearPhoenix.Card
  alias CrambearPhoenix.Tag
  alias CrambearPhoenix.Repo
  alias JaSerializer.Params

  schema "cards" do
    belongs_to :cardset, Cardset
    many_to_many :tags, Tag, join_through: "cards_tags"
    field :front, :string
    field :back, :string

    timestamps
  end

  @required_fields ~w(front back)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def create(params) do
    changeset = Card.changeset(%Card{}, Params.to_attributes(params))
    case Repo.insert(changeset) do
      {:ok, card} ->
        count = Repo.all(from c in Card, where: [cardset_id: ^card.cardset_id]).length
        card_count_change = %{card_count: count}
        Repo.get(Cardset, card.cardset_id)
          |> Cardset.changeset(card_count_change)
          |> Repo.update

        {:ok, card}
      other -> other
    end
  end

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
