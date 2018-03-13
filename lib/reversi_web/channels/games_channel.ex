defmodule ReversiWeb.GamesChannel do
  use ReversiWeb, :channel

  alias Reversi.Play

  def join("games:" <> game_id, payload, socket) do
    if authorized?(payload) do
      game = Play.get_game(game_id)
      state = Play.get_current_state(game_id)
      socket = socket
      |> assign(:game, game)
      |> assign(:game_id, game_id)
      |> assign(:state, state)
      {:ok, %{"join" => game_id, "game" => Play.client_view(state.id)}, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # returns an updated view state when a "select" message is received
  def handle_in("select", %{"grid_index" => gi, "current_user_id" => cuid, "state_id" => si}, socket) do
    state_id = Play.select(si, gi, cuid)
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id)}}, socket}
  end

  # returns an updated view state when a "concede" message is received
  def handle_in("concede", %{"current_user_id" => cuid, "state_id" => si}, socket) do
    state_id = Play.concede(si, cuid)
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id)}}, socket}
  end

  # returns the initial view state of this session's game
  def handle_in("init",  %{"state_id" => state_id}, socket) do
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id, "init")}}, socket}
  end

  # returns the current view state of this session's game
  def handle_in("now", %{"state_id" => state_id}, socket) do
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id, "now")}}, socket}
  end

  # returns the previous view state of this session's game
  def handle_in("prev", %{"state_id" => state_id}, socket) do
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id, "prev")}}, socket}
  end

  # returns the next view state of this session's game
  def handle_in("next", %{"state_id" => state_id}, socket) do
    state = Play.get_state(state_id)
    game = Play.get_game(state.game_id)
    socket = assign(socket, :game, game)
    {:reply, {:ok, %{ "game" => Play.client_view(state_id, "next")}}, socket}
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
