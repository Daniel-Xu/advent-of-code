defmodule AOC17.Day12 do
  use Utils

  def part_one(),
    do: input() |> handle(0) |> MapSet.size()

  def part_two() do
    input = input()
    l = Enum.map(input, &elem(&1, 0))
    process_group(l, input, false, MapSet.new(l), 0)
  end

  def process(l, target, m) do
    m = MapSet.put(m, target)
    connected(l, target)
    |> Enum.reduce(m, fn(n, m) ->
      if MapSet.member?(m, n),
        do: m,
        else: process(l, n, m)
    end)
  end

  def process_group(_l, _i, true, _m, acc), do: acc
  def process_group([h | t], i, _stop, m, acc) do
    stop = if MapSet.size(m) == 0, do: true, else: false
    if MapSet.member?(m, h) do
      g = handle(i, h)
      m = MapSet.difference(m, g)
      process_group(t, i, stop, m, acc + 1)
    else
      process_group(t, i, stop, m, acc)
    end
  end

  defp input(name \\ "data/2017/day12.txt"),
    do: normalize_file(name, " <-> ") |> Enum.to_list()

  defp handle(input, n), do: process(input, n, MapSet.new([]))

  defp connected(l, n) do
    Enum.find(l, fn({x, _}) -> x == n end)
    |> elem(1)
  end

  def normalize_line(data, pattern) do
    [s, l] = String.split(data, pattern)
    l =
      String.split(l, ", ")
      |> Enum.map(&String.to_integer/1)
    {String.to_integer(s), l}
  end
end
