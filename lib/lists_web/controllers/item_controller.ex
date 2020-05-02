defmodule ListsWeb.ItemController do
  use ListsWeb, :controller
  alias Lists.{Repo, Item}

  def index(conn, _params) do
    items = Repo.all(Item)
    render(conn, "index.html", items: items)
  end
end
