defmodule ReversiWeb.PageController do
  use ReversiWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
