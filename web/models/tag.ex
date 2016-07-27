defmodule CrambearPhoenix.Tag do
  use CrambearPhoenix.Web, :model
  alias CrambearPhoenix.Cardset
  alias CrambearPhoenix.Card

  schema "tags" do
    belongs_to :cardset, Cardset
    many_to_many :cards, Card, join_through: "cards_tags"
    field :name, :string

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
