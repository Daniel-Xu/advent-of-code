defmodule Day13Test do
  use ExUnit.Case

  test "open?" do
    assert Day13.open?(%{x: 1, y: 0}, 10) == false
    assert Day13.open?(%{x: 2, y: 0}, 10) == true
    assert Day13.open?(%{x: 7, y: 4}, 10) == true
  end
end
