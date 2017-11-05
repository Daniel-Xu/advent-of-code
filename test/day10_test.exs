defmodule Day10Test do
  use ExUnit.Case

  test "process" do
    output =
      Day10.process("data/day10_test.txt")
      |> get_in(["output0", :values])
    assert output == [5]
  end

end
