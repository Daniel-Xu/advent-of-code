defmodule AOC17.Day13 do
  use Utils

  def part_one(), do: state() |> handle()
  def part_two(), do: state() |> process_step(false, 0)

  def handle(state), do: process(state, 0, []) |> Enum.sum()

  def state(name \\ "data/2017/day13.txt"),
    do: normalize_file(name, ": ") |> Enum.to_list()

  def process_step(_state, true, acc), do: acc - 1
  def process_step(state, _v, acc) do
    v = process(state, acc, []) == []
    process_step(state, v, acc + 1)
  end

  def process([], _i, acc), do: acc
  def process([{l, r} | t], i, acc) do
    acc = if rem(l + i, (r - 1) * 2) == 0, do: [l * r | acc], else: acc
    process(t, i, acc)
  end

  def normalize_line(data, pattern) do
    [l, r] = String.split(data, pattern) |> Enum.map(&String.to_integer/1)
    {l, r}
  end
end
