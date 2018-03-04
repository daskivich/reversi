defmodule ReversiWeb.SessionController do
  use ReversiWeb, :controller

  alias Reversi.Accounts

  def create(conn, %{"email" => email}) do
    user = Accounts.get_user_by_email(email)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back, #{user.name}!")
      |> redirect(to: page_path(conn, :home))
    else
      conn
      |> put_flash(:error, "Invalid credentials!")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out!")
    |> redirect(to: page_path(conn, :index))
  end
end
