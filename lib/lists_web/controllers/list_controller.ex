defmodule ListsWeb.ListController do
  import Ecto.Query
  use ListsWeb, :controller
  alias Lists.{Repo, List, Item}

  def index(conn, _params) do
    query = from l in List, order_by: l.inserted_at
    lists = Repo.all(query)
    render(conn, "index.html", lists: lists)
  end

  def show(conn, params) do
    list = Repo.get!(List, params["id"])
    query = from i in Item, order_by: i.inserted_at, where: i.list_id == ^list.id
    items = Repo.all(query)
    render(conn, "show.html", list: list, items: items)
  end
end
