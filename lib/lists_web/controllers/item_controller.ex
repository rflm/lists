defmodule ListsWeb.ItemController do
  use ListsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
