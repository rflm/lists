defmodule Lists.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    belongs_to :list, Lists.List

    field :description, :string
    field :checked, :boolean

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:description, :checked])
    |> validate_required([:description, :list_id])
  end
end
