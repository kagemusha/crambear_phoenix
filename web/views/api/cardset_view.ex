defmodule CrambearPhoenix.Api.CardsetView do
  use CrambearPhoenix.Web, :view

  has_many :cards, serializer: CrambearPhoenix.Api.CardView
#  has_many :tags, serializer: CrambearPhoenix.TagView

  attributes [:name, :card_count, :inserted_at, :updated_at]

  def cards(struct, _conn) do
    case struct.cards do
      %Ecto.Association.NotLoaded{} ->
        []
      other -> other
    end
  end

end
