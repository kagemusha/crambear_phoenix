defmodule CrambearPhoenix.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :cardset_id, references(:cardsets, on_delete: :delete_all)
      add :front, :string
      add :back, :string

      timestamps
    end

  end
end
