defmodule Lists.ListControllerTest do
  use ListsWeb.ConnCase

  alias Lists.{Repo, List}

  @create_attrs %{name: "Test name"}

  test "GET /", %{conn: conn} do
    create_list(@create_attrs)

    conn = get(conn, "/")
    assert html_response(conn, 200) =~ @create_attrs.name
  end

  describe "create list" do
    test "returns json with list when success", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), name: @create_attrs.name)
      assert %{"id" => _, "name" => name} = json_response(conn, 201)
      assert name == @create_attrs.name
    end

    test "return json with error when fail", %{conn: conn} do
      conn = post(conn, Routes.list_path(conn, :create), name: "")
      assert %{"errors" => [%{"name" => error}]} = json_response(conn, 422)
      assert error, "can't be blank"
    end
  end

  test "DELETE /:id", %{conn: conn} do
    {:ok, %List{} = list} = create_list(@create_attrs)

    conn = delete(conn, Routes.list_path(conn, :delete, list))
    assert response(conn, 200)

    assert nil == Repo.get(List, list.id)
  end

  test "GET /:id", %{conn: conn} do
    {:ok, %List{} = list} = create_list(@create_attrs)
    conn = get(conn, Routes.list_path(conn, :show, list))
    assert response(conn, 200)
  end

  defp create_list(attrs) do
    %List{}
    |> List.changeset(attrs)
    |> Repo.insert()
  end
end
