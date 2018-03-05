defmodule ReversiWeb.StateView do
  use ReversiWeb, :view
  alias ReversiWeb.StateView

  def render("index.json", %{states: states}) do
    %{data: render_many(states, StateView, "state.json")}
  end

  def render("show.json", %{state: state}) do
    %{data: render_one(state, StateView, "state.json")}
  end

  def render("state.json", %{state: state}) do
    %{id: state.id,
      player_ones_turn: state.player_ones_turn,
      r1c1: state.r1c1,
      r1c2: state.r1c2,
      r1c3: state.r1c3,
      r1c4: state.r1c4,
      r1c5: state.r1c5,
      r1c6: state.r1c6,
      r1c7: state.r1c7,
      r1c8: state.r1c8,
      r2c1: state.r2c1,
      r2c2: state.r2c2,
      r2c3: state.r2c3,
      r2c4: state.r2c4,
      r2c5: state.r2c5,
      r2c6: state.r2c6,
      r2c7: state.r2c7,
      r2c8: state.r2c8,
      r3c1: state.r3c1,
      r3c2: state.r3c2,
      r3c3: state.r3c3,
      r3c4: state.r3c4,
      r3c5: state.r3c5,
      r3c6: state.r3c6,
      r3c7: state.r3c7,
      r3c8: state.r3c8,
      r4c1: state.r4c1,
      r4c2: state.r4c2,
      r4c3: state.r4c3,
      r4c4: state.r4c4,
      r4c5: state.r4c5,
      r4c6: state.r4c6,
      r4c7: state.r4c7,
      r4c8: state.r4c8,
      r5c1: state.r5c1,
      r5c2: state.r5c2,
      r5c3: state.r5c3,
      r5c4: state.r5c4,
      r5c5: state.r5c5,
      r5c6: state.r5c6,
      r5c7: state.r5c7,
      r5c8: state.r5c8,
      r6c1: state.r6c1,
      r6c2: state.r6c2,
      r6c3: state.r6c3,
      r6c4: state.r6c4,
      r6c5: state.r6c5,
      r6c6: state.r6c6,
      r6c7: state.r6c7,
      r6c8: state.r6c8,
      r7c1: state.r7c1,
      r7c2: state.r7c2,
      r7c3: state.r7c3,
      r7c4: state.r7c4,
      r7c5: state.r7c5,
      r7c6: state.r7c6,
      r7c7: state.r7c7,
      r7c8: state.r7c8,
      r8c1: state.r8c1,
      r8c2: state.r8c2,
      r8c3: state.r8c3,
      r8c4: state.r8c4,
      r8c5: state.r8c5,
      r8c6: state.r8c6,
      r8c7: state.r8c7,
      r8c8: state.r8c8}
  end
end
