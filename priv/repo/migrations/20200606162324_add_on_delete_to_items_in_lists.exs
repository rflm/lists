defmodule Lists.Repo.Migrations.AddOnDeleteToItemsInLists do
  use Ecto.Migration

  def change do
    alter table("items") do
      modify :list_id, references(:lists, on_delete: :delete_all),
        from: references(:lists, on_delete: :nothing)
    end
  end
end
