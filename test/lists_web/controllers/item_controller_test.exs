defmodule Lists.ItemControllerTest do
  use ListsWeb.ConnCase

  alias Lists.{Repo, Item, List}

  @create_attrs %{description: "Test description"}

  describe "create item" do
    test "returns json with item when success", %{conn: conn} do
      {:ok, %List{} = list} = create_list()
      conn = post(
        conn,
        Routes.list_item_path(conn, :create, list),
        description: @create_attrs.description
      )

      assert %{"id" => _, "description" => description} = json_response(conn, 201)
      assert description == @create_attrs.description
    end

    test "return json with error when fail", %{conn: conn} do
      {:ok, %List{} = list} = create_list()
      conn = post(
        conn,
        Routes.list_item_path(conn, :create, list),
        description: ""
      )

      assert %{"errors" => [%{"description" => error}]} = json_response(conn, 422)
      assert error == "can't be blank"
    end
  end

  test "check item", %{conn: conn} do
    {:ok, %List{} = list} = create_list()
    {:ok, %Item{} = item} =
      create_item(Map.merge(@create_attrs, %{list_id: list.id}))

    conn = post(conn, Routes.list_item_check_path(conn, :check, list, item.id))
    assert response(conn, 200)

    item = Repo.get!(Item, item.id)
    assert item.checked == true
  end

  test "uncheck item", %{conn: conn} do
    {:ok, %List{} = list} = create_list()
    {:ok, %Item{} = item} =
      create_item(Map.merge(@create_attrs, %{list_id: list.id, checked: true}))

    conn = post(
      conn,
      Routes.list_item_uncheck_path(conn, :uncheck, list, item.id)
    )
    assert response(conn, 200)

    item = Repo.get!(Item, item.id)
    assert false == item.checked
  end

  test "DELETE /:id", %{conn: conn} do
    {:ok, %List{} = list} = create_list()
    {:ok, %Item{} = item} =
      create_item(Map.merge(@create_attrs, %{list_id: list.id}))

    conn = delete(conn, Routes.list_item_path(conn, :delete, list, item))
    assert response(conn, 200)


    assert nil == Repo.get(Item, item.id)
  end

  defp create_list do
    %List{}
    |> List.changeset(%{name: "my list"})
    |> Repo.insert()
  end

  defp create_item(attrs) do
    Item.changeset(%Item{}, attrs)
    |> Repo.insert()
  end
end
