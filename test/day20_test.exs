defmodule Day20Test do
  use ExUnit.Case

  test "part_one" do
    assert Day20.part_one("data/day20_test.txt")  == 3
  end

  test "part_two" do
    assert Day20.part_two("data/day20_test.txt", 9)  == 2
  end
end
