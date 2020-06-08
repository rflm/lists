defmodule ListsWeb.SessionController do
  use ListsWeb, :controller

  alias Lists.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => auth_params}) do
    user = Accounts.User.get_by_username(auth_params["username"])
    case Argon2.check_pass(user, auth_params["password"]) do
    {:ok, user} ->
      conn
      |> put_session(:current_user_id, user.id)
      |> put_flash(:info, "Signed in successfully.")
      |> redirect(to: Routes.list_path(conn, :index))
    {:error, _} ->
      conn
      |> put_status(422)
      |> put_flash(:error, "There was a problem with your username/password")
      |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:current_user_id)
    |> put_flash(:info, "Signed out successfully.")
    |> redirect(to: Routes.list_path(conn, :index))
  end
end
