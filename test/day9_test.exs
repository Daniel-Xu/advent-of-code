defmodule Day9Test do
  use ExUnit.Case

  test "process" do
    assert Day9.process("A(1x5)BC") == 7
    assert Day9.process("A(2x2)BCDabc(2x2)EFG") == 14
    assert Day9.process("X(8x2)(3x3)ABCY") == 18
    assert Day9.process("(26x6)abcdefghijklmnopqrstuvwxyz(2x3)ZE") == 162
  end

  test "calculate" do
    assert Day9.process("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN", true) == 445
    # assert Day9.calculate("") == 0
    assert Day9.process("(27x12)(20x12)(13x14)(7x10)(1x12)A", true) == 241920
  end
end
