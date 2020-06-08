defmodule ListsWeb.SessionControllerTest do
  use ListsWeb.ConnCase

  alias Lists.Accounts

  @create_attrs %{
    encrypted_password: "some encrypted_password",
    username: "some username"
  }

  describe "new session" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.session_path(conn, :new))
      assert html_response(conn, 200) =~ "username"
    end
  end

  describe "create session" do
    test "redirects to list index when data is valid", %{conn: conn} do
      create_user()
      conn = login_user(conn)

      assert redirected_to(conn) == Routes.list_path(conn, :index)
    end

    test "renders error when data is invalid", %{conn: conn} do
      create_user()

      conn = post(
        conn,
        Routes.session_path(conn, :create),
        %{
          session: %{
            username: @create_attrs.username,
            password: "aaaa"
          }
        }
      )

      assert html_response(conn, 422) =~
        "There was a problem with your username/password"
    end
  end

  describe "delete session" do
    test "redirects to lists when session is destroyed", %{conn: conn} do
      create_user()
      login_user(conn)

      conn = delete(
        conn,
        Routes.session_path(conn, :delete)
      )

      assert redirected_to(conn) == Routes.list_path(conn, :index)
    end
  end

  defp create_user do
    Accounts.create_user(@create_attrs)
  end

  defp login_user(conn) do
    post(
      conn,
      Routes.session_path(conn, :create),
      %{
        session: %{
          username: @create_attrs.username,
          password: @create_attrs.encrypted_password
        }
      }
    )
  end
end
