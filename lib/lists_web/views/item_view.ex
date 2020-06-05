defmodule ListsWeb.ItemView do
  use ListsWeb, :view
  import Lists.Helpers

  def render("show.json", %{item: item}) do
    item_json(item)
  end

  def render("show.json", %{errors: errors}) do
    %{
      status: 422,
      errors: mapped_errors(errors)
    }
  end

  defp item_json(item) do
    %{
      id: item.id,
      checked: item.checked,
      description: item.description
    }
  end
end
