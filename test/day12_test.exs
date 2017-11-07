defmodule Day12Test do
  use ExUnit.Case
  test "process" do
    state = Day12.handle("data/day12_test.txt")
    assert Map.get(state, "d") == 25
  end
end
