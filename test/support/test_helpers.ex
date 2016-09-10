defmodule CrambearPhoenix.TestHelpers do
  alias CrambearPhoenix.Repo
  alias CrambearPhoenix.Cardset

  def insert_cardset(attrs \\ %{}) do
    defaults =  %{
      "name" => "Elixir",
    }
    attrs = Map.merge(attrs, defaults)
    changeset = Cardset.changeset(%Cardset{}, attrs)
    Repo.insert!(changeset)
  end

end