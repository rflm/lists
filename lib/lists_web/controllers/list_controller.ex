defmodule ListsWeb.ListController do
  import Ecto.Query
  use ListsWeb, :controller
  alias Lists.{Repo, List, Item}

  def index(conn, _params) do
    query = from l in List, order_by: l.inserted_at
    lists = Repo.all(query)
    render(conn, "index.html", lists: lists)
  end

  def create(conn, params) do
    attrs = create_params(params)

    with {:ok, %List{} = list} <- create_list(attrs) do
      conn
      |> put_status(201)
      |> render("show.json", list: list)
    else
      {:error, %Ecto.Changeset{errors: errors}} ->
        conn
        |> put_status(422)
        |> render("show.json", errors: errors)
    end
  end

  def show(conn, params) do
    list = Repo.get!(List, params["id"])
    query = from i in Item, order_by: i.inserted_at, where: i.list_id == ^list.id
    items = Repo.all(query)
    render(conn, "show.html", list: list, items: items)
  end

  defp create_list(attrs) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end

  defp create_params(params) do
    Map.take(params, ["name"])
  end
end
