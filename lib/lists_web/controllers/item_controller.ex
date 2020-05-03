defmodule ListsWeb.ItemController do
  use ListsWeb, :controller
  alias Lists.{Repo, Item}

  def index(conn, _params) do
    items = Repo.all(Item)
    render(conn, "index.html", items: items)
  end

  def create(conn, params) do
    attrs = create_params(params)

    with {:ok, %Item{} = item} <- create_item(attrs) do
      conn
      |> put_status(201)
      |> render("show.json", item: item)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn
        |> put_status(422)
        |> render("show.json", errors: errors)
    end
  end

  def delete(conn, params) do
    item = Repo.get!(Item, params["id"])

    with {:ok, _ } <- Repo.delete(item) do
      conn
      |> render("show.json", item: item)
    end
  end

  defp create_item(attrs) do
    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
  end

  defp create_params(params) do
    Map.take(params, ["description"])
  end
end
