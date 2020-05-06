defmodule Lists.Repo.Migrations.ItemsAddListId do
  use Ecto.Migration

  def change do
    alter table("items") do
      add :list_id, references(:lists), null: false
    end
  end
end
