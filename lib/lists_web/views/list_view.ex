defmodule ListsWeb.ListView do
  use ListsWeb, :view
  import Lists.Helpers

  def render("show.json", %{list: list}) do
    list_json(list)
  end

  def render("show.json", %{errors: errors}) do
    %{
      status: 422,
      errors: mapped_errors(errors)
    }
  end

  defp list_json(list) do
    %{
      id: list.id,
      name: list.name
    }
  end
end
