defmodule Lists.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :description, :string, null: false
      add :checked, :boolean, null: false, default: false

      timestamps()
    end

  end
end
