defmodule CrambearPhoenix.Api.CardsetView do
  use CrambearPhoenix.Web, :view

  def render("index.json", %{cardsets: cardsets}) do
    %{cardsets: Enum.map(cardsets, &( %{
          id: &1.id,
          name: &1.name,
        }
    ))}
  end

end
