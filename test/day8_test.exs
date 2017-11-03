defmodule Day8Test do
  use ExUnit.Case

  setup do
    board = [
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0, 0, 0]
    ]
    {:ok, board: board}
  end

  test "Day8.turn_on_rect", %{board: board} do
    new_board = Day8.turn_on_rect(board, 3, 2)
    assert new_board ==
      [
        [1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 0, 0]
      ]

    new_board = Day8.rotate_column(new_board, 1, 1)
    assert new_board ==
      [
        [1, 0, 1, 0, 0, 0, 0],
        [1, 1, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0]
      ]

    new_board = Day8.rotate_row(new_board, 0, 4)
    assert new_board ==
      [
        [0, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0]
      ]

    new_board = Day8.rotate_column(new_board, 1, 1)
    assert new_board ==
      [
        [0, 1, 0, 0, 1, 0, 1],
        [1, 0, 1, 0, 0, 0, 0],
        [0, 1, 0, 0, 0, 0, 0]
      ]
  end

  test "parse" do
    assert Day8.part_one("data/day8_test.txt")  == 6
  end
end
