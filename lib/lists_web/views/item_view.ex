defmodule ListsWeb.ItemView do
  use ListsWeb, :view

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
      description: item.description
    }
  end

  defp mapped_errors(errors) do
    errors
    |> Enum.map fn {attr, {message, _}} -> %{attr => message} end
  end
end
