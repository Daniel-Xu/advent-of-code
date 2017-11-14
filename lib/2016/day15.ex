defmodule Day15 do
  @test [
    %{pos: 4, n: 5, diff: 1},
    %{pos: 1, n: 2, diff: 2},
  ]

  @discs [
    %{pos: 2, n: 5, diff: 1},
    %{pos: 7, n: 13, diff: 2},
    %{pos: 10, n: 17, diff: 3},
    %{pos: 2, n: 3, diff: 4},
    %{pos: 9, n: 19, diff: 5},
    %{pos: 0, n: 7, diff: 6}
  ]

  @new_discs @discs ++ [%{pos: 0, n: 11, diff: 7}]

  def pass?(state) do
    Enum.map(state, fn(%{pos: pos}) -> pos end)
    |> Enum.sum()
    |> Kernel.==(0)
  end

  def run(_state, time, _pass = true), do: time - 1
  def run(state, time, _pass) do
    pass = once(state, time) |> pass?()
    run(state, time + 1, pass)
  end

  def once(state, time) do
    Enum.map(state, fn(%{pos: pos, n: n, diff: diff} = disc) ->
      pos = rem(pos + time + diff, n)
      %{disc | pos: pos}
    end)
  end

  def init_test(), do: @test
  def init_disc(), do: @discs
  def init_new_disc(), do: @new_discs
end
