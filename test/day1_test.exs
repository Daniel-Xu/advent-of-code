defmodule Day1Test do
  use ExUnit.Case

  test "part_two" do
    assert Day1.part_two("data/day1_test.txt") == MapSet.new([[4, 0]])
  end
end
