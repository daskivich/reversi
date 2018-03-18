defmodule ReversiWeb.SessionController do
  use ReversiWeb, :controller

  alias Reversi.Accounts

  def create(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_and_auth_user(email, password)

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
