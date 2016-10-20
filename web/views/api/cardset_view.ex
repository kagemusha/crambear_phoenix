defmodule CrambearPhoenix.Api.CardsetView do
  use CrambearPhoenix.Web, :view
  alias CrambearPhoenix.Repo

  has_many :cards,
    serializer: CrambearPhoenix.Api.CardView,
    include: true
#  has_many :tags, serializer: CrambearPhoenix.TagView

  attributes [:name, :card_count, :is_mine, :inserted_at, :updated_at]

  def cards(struct, conn) do
    case struct.cards do
      %Ecto.Association.NotLoaded{} ->
        struct
        |> Ecto.assoc(:cards)
        |> Repo.all
      other -> other
    end
  end

  def is_mine(cardset, conn) do
    cardset = Repo.preload cardset, :user
    Map.has_key?(conn.assigns, :current_user) && conn.assigns.current_user == cardset.user
  end
end
