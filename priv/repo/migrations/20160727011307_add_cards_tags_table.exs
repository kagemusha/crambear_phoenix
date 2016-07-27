defmodule CrambearPhoenix.Repo.Migrations.AddCardsTagsTable do
  use Ecto.Migration

  def change do
    create table(:cards_tags) do
      add :card_id, :integer
      add :tag_id, :integer
    end
  end
end
