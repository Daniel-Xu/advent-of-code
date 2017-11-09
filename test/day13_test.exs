defmodule Day13Test do
  use ExUnit.Case

  test "open?" do
    assert Day13.open?(1, 0, 10) == false
    assert Day13.open?(2, 0, 10) == true
    assert Day13.open?(7, 4, 10) == true
  end
end
