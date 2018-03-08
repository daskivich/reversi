defmodule ReversiWeb.GamesChannel do
  use ReversiWeb, :channel

  alias Reversi.Play

  def join("games:" <> game_id, payload, socket) do
    if authorized?(payload) do
      game = Play.get_game(game_id)
      state = Play.get_current_state(game_id)
      # TODO: assuming game already exists; handle new game case if necessary
      socket = socket
      |> assign(:game, game)
      |> assign(:game_id, game_id)
      |> assign(:state, state)
      {:ok, %{"join" => game_id, "game" => Play.client_view(game_id)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # returns an updated view state when a "select" message is received
  def handle_in("select", %{"grid_index" => gi, "current_user_id" => cuid}, socket) do
    game = Play.select(socket.assigns[:game], gi, cuid)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(game.id)}}, socket}
  end



  # # Channels can be used in a request/response fashion
  # # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end
  #
  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (games:lobby).
  # def handle_in("shout", payload, socket) do
  #   broadcast socket, "shout", payload
  #   {:noreply, socket}
  # end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
