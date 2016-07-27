defmodule CrambearPhoenix.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tags) do
      add :cardset_id, references(:cardsets)
      add :name, :string

      timestamps
    end

  end
end
