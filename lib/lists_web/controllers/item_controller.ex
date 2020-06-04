defmodule ListsWeb.ItemController do
  import Ecto.Query
  use ListsWeb, :controller
  alias Lists.{Repo, Item, List}

  def index(conn, _params) do
    query = from i in Item, order_by: i.inserted_at
    items = Repo.all(query)
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

  def check(conn, params) do
    toggle_checked(conn, params["item_id"], true)
  end

  def uncheck(conn, params) do
    toggle_checked(conn, params["item_id"], false)
  end

  def delete(conn, params) do
    item = Repo.get!(Item, params["id"])

    with {:ok, _ } <- Repo.delete(item) do
      conn
      |> render("show.json", item: item)
    end
  end

  defp create_item(attrs) do
    Item.changeset(%Item{}, attrs)
    |> Repo.insert()
  end

  defp create_params(params) do
    Map.take(params, ["list_id", "description"])
  end

  defp toggle_checked(conn, id, checked) do
    item = Repo.get!(Item, id)
    item = Ecto.Changeset.change item, checked: checked

    with {:ok, %Item{} = item} <- Repo.update(item) do
      conn
      |> render("show.json", item: item)
    end
  end
end
