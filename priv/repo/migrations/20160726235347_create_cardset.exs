defmodule CrambearPhoenix.Repo.Migrations.CreateCardset do
  use Ecto.Migration

  def change do
    create table(:cardsets) do
      add :user_id, references(:users)
      add :name, :string
      add :public, :boolean, default: false
      add :card_count, :integer, default: 0

      timestamps
    end

  end
end
