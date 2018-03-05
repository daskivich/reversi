defmodule ReversiWeb.StateControllerTest do
  use ReversiWeb.ConnCase

  alias Reversi.Play
  alias Reversi.Play.State

  @create_attrs %{r2c6: 42, r5c3: 42, r2c8: 42, r3c6: 42, r4c1: 42, r5c4: 42, r1c5: 42, r8c4: 42, r4c5: 42, r6c8: 42, r1c6: 42, r8c1: 42, r4c3: 42, r8c7: 42, r2c7: 42, r5c8: 42, r7c7: 42, r2c5: 42, r8c3: 42, r8c5: 42, r8c6: 42, r1c8: 42, r4c6: 42, r7c5: 42, r6c2: 42, r8c8: 42, r7c6: 42, r2c3: 42, r6c1: 42, r2c1: 42, r7c3: 42, r3c5: 42, r4c7: 42, r2c4: 42, r4c8: 42, r3c1: 42, r1c7: 42, r7c8: 42, r6c6: 42, r7c4: 42, r6c3: 42, r3c7: 42, r6c4: 42, r4c2: 42, r1c2: 42, r5c1: 42, r8c2: 42, r6c7: 42, r7c1: 42, player_ones_turn: true, ...}
  @update_attrs %{r2c6: 43, r5c3: 43, r2c8: 43, r3c6: 43, r4c1: 43, r5c4: 43, r1c5: 43, r8c4: 43, r4c5: 43, r6c8: 43, r1c6: 43, r8c1: 43, r4c3: 43, r8c7: 43, r2c7: 43, r5c8: 43, r7c7: 43, r2c5: 43, r8c3: 43, r8c5: 43, r8c6: 43, r1c8: 43, r4c6: 43, r7c5: 43, r6c2: 43, r8c8: 43, r7c6: 43, r2c3: 43, r6c1: 43, r2c1: 43, r7c3: 43, r3c5: 43, r4c7: 43, r2c4: 43, r4c8: 43, r3c1: 43, r1c7: 43, r7c8: 43, r6c6: 43, r7c4: 43, r6c3: 43, r3c7: 43, r6c4: 43, r4c2: 43, r1c2: 43, r5c1: 43, r8c2: 43, r6c7: 43, r7c1: 43, player_ones_turn: false, ...}
  @invalid_attrs %{r2c6: nil, r5c3: nil, r2c8: nil, r3c6: nil, r4c1: nil, r5c4: nil, r1c5: nil, r8c4: nil, r4c5: nil, r6c8: nil, r1c6: nil, r8c1: nil, r4c3: nil, r8c7: nil, r2c7: nil, r5c8: nil, r7c7: nil, r2c5: nil, r8c3: nil, r8c5: nil, r8c6: nil, r1c8: nil, r4c6: nil, r7c5: nil, r6c2: nil, r8c8: nil, r7c6: nil, r2c3: nil, r6c1: nil, r2c1: nil, r7c3: nil, r3c5: nil, r4c7: nil, r2c4: nil, r4c8: nil, r3c1: nil, r1c7: nil, r7c8: nil, r6c6: nil, r7c4: nil, r6c3: nil, r3c7: nil, r6c4: nil, r4c2: nil, r1c2: nil, r5c1: nil, r8c2: nil, r6c7: nil, r7c1: nil, player_ones_turn: nil, ...}

  def fixture(:state) do
    {:ok, state} = Play.create_state(@create_attrs)
    state
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all states", %{conn: conn} do
      conn = get conn, state_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create state" do
    test "renders state when data is valid", %{conn: conn} do
      conn = post conn, state_path(conn, :create), state: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, state_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "r2c6" => 42,
        "r5c3" => 42,
        "r2c8" => 42,
        "r3c6" => 42,
        "r4c1" => 42,
        "r5c4" => 42,
        "r1c5" => 42,
        "r8c4" => 42,
        "r4c5" => 42,
        "r6c8" => 42,
        "r1c6" => 42,
        "r8c1" => 42,
        "r4c3" => 42,
        "r8c7" => 42,
        "r2c7" => 42,
        "r5c8" => 42,
        "r7c7" => 42,
        "r2c5" => 42,
        "r8c3" => 42,
        "r8c5" => 42,
        "r8c6" => 42,
        "r1c8" => 42,
        "r4c6" => 42,
        "r7c5" => 42,
        "r6c2" => 42,
        "r8c8" => 42,
        "r7c6" => 42,
        "r2c3" => 42,
        "r6c1" => 42,
        "r2c1" => 42,
        "r7c3" => 42,
        "r3c5" => 42,
        "r4c7" => 42,
        "r2c4" => 42,
        "r4c8" => 42,
        "r3c1" => 42,
        "r1c7" => 42,
        "r7c8" => 42,
        "r6c6" => 42,
        "r7c4" => 42,
        "r6c3" => 42,
        "r3c7" => 42,
        "r6c4" => 42,
        "r4c2" => 42,
        "r1c2" => 42,
        "r5c1" => 42,
        "r8c2" => 42,
        "r6c7" => 42,
        "r7c1" => 42,
        "player_ones_turn" => true,
        "r3c4" => 42,
        "r5c7" => 42,
        "r5c6" => 42,
        "r3c8" => 42,
        "r2c2" => 42,
        "r5c5" => 42,
        "r4c4" => 42,
        "r5c2" => 42,
        "r7c2" => 42,
        "r1c3" => 42,
        "r1c1" => 42,
        "r1c4" => 42,
        "r3c3" => 42,
        "r3c2" => 42,
        "r6c5" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, state_path(conn, :create), state: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update state" do
    setup [:create_state]

    test "renders state when data is valid", %{conn: conn, state: %State{id: id} = state} do
      conn = put conn, state_path(conn, :update, state), state: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, state_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "r2c6" => 43,
        "r5c3" => 43,
        "r2c8" => 43,
        "r3c6" => 43,
        "r4c1" => 43,
        "r5c4" => 43,
        "r1c5" => 43,
        "r8c4" => 43,
        "r4c5" => 43,
        "r6c8" => 43,
        "r1c6" => 43,
        "r8c1" => 43,
        "r4c3" => 43,
        "r8c7" => 43,
        "r2c7" => 43,
        "r5c8" => 43,
        "r7c7" => 43,
        "r2c5" => 43,
        "r8c3" => 43,
        "r8c5" => 43,
        "r8c6" => 43,
        "r1c8" => 43,
        "r4c6" => 43,
        "r7c5" => 43,
        "r6c2" => 43,
        "r8c8" => 43,
        "r7c6" => 43,
        "r2c3" => 43,
        "r6c1" => 43,
        "r2c1" => 43,
        "r7c3" => 43,
        "r3c5" => 43,
        "r4c7" => 43,
        "r2c4" => 43,
        "r4c8" => 43,
        "r3c1" => 43,
        "r1c7" => 43,
        "r7c8" => 43,
        "r6c6" => 43,
        "r7c4" => 43,
        "r6c3" => 43,
        "r3c7" => 43,
        "r6c4" => 43,
        "r4c2" => 43,
        "r1c2" => 43,
        "r5c1" => 43,
        "r8c2" => 43,
        "r6c7" => 43,
        "r7c1" => 43,
        "player_ones_turn" => false,
        "r3c4" => 43,
        "r5c7" => 43,
        "r5c6" => 43,
        "r3c8" => 43,
        "r2c2" => 43,
        "r5c5" => 43,
        "r4c4" => 43,
        "r5c2" => 43,
        "r7c2" => 43,
        "r1c3" => 43,
        "r1c1" => 43,
        "r1c4" => 43,
        "r3c3" => 43,
        "r3c2" => 43,
        "r6c5" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, state: state} do
      conn = put conn, state_path(conn, :update, state), state: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete state" do
    setup [:create_state]

    test "deletes chosen state", %{conn: conn, state: state} do
      conn = delete conn, state_path(conn, :delete, state)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, state_path(conn, :show, state)
      end
    end
  end

  defp create_state(_) do
    state = fixture(:state)
    {:ok, state: state}
  end
end
