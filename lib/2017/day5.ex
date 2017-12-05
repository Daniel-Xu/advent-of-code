defmodule AOC17.Day5 do
  use Utils

  def handle(name \\ "data/2017/day5.txt")  do
    l =
      normalize_file(name)
      |> Enum.with_index()

    m = for {x, i} <- l, into: %{}, do: {i, x}
    process(m, 0, map_size(m), 0)
  end

  def process(_l, i, len, acc) when i < 0 or i >= len, do: acc
  def process(l, i, len, acc) do
    diff = if Map.get(l, i) >= 3, do: -1, else: 1
    # diff = 1 for part one
    process(Map.update!(l, i, &(&1 + diff)), i + Map.get(l, i), len, acc + 1)
  end

  def normalize_line(data, _pattern), do: String.to_integer(data)
end
