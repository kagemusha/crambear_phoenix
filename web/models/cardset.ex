defmodule CrambearPhoenix.Cardset do
  use CrambearPhoenix.Web, :model

  schema "cardsets" do
    has_many :cards, Card
    has_many :tags, Tag
    field :name, :string
    field :public, :boolean, default: false

    timestamps
  end

  @required_fields ~w(name public)
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