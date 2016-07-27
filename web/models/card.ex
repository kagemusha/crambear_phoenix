defmodule CrambearPhoenix.Card do
  use CrambearPhoenix.Web, :model
  alias CrambearPhoenix.Cardset
  alias CrambearPhoenix.Tag

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
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
