defmodule Day2Test do
  use ExUnit.Case

  test "test keyboard" do
    assert Day2.keyboard()["4"]["U"] == "1"
  end

  test "test process" do
    assert Day2.process("5", ["U", "L", "L"]) == "1"
  end
end
