defmodule Day19Test do
  use ExUnit.Case

  test "process" do
    assert Day19.process(1..5, 5) == 3
    assert Day19.process(1..13, 13) == 11
    assert Day19.process(1..41, 41) == 19
  end

  test "run" do
    assert Day19.run(40) == 13
    assert Day19.run(7) == 5
    assert Day19.run(5) == 2
  end
end
