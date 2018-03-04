defmodule ReversiWeb.PageController do
  use ReversiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  # if a user is logged in, render the home page
  # otherwise redirect to the log-in page (see index above)
  def home(conn, _params) do
    user_id = get_session(conn, :user_id)

    if user_id do
  #    tasks = TaskTracker.Work.list_tasks()
  #    changeset = TaskTracker.Work.change_task(%TaskTracker.Work.Task{})
  #    users = TaskTracker.Accounts.list_users()
      render conn, "home.html"#, tasks: tasks, changeset: changeset, users: users
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end

  def game(conn, params) do
    user_id = get_session(conn, :user_id)

    if user_id do
      render conn, "game.html", game: params["game"]
    else
      conn
      |> redirect(to: page_path(conn, :index))
    end
  end
end
