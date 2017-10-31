defmodule Day6 do
  use Utils

  def part_one() do
    stream_file("data/day6.txt", fn(map) ->
      Enum.max_by(map, &(elem(&1, 1)))
    end)
  end

  def part_two() do
    stream_file("data/day6.txt", fn(map) ->
      Enum.min_by(map, &(elem(&1, 1)))
    end)
  end

  def stream_file(name, fun) do
    normalize_file(name, "")
    # [["a", "b", "c"], ["e", "d", "f"]]
    # [{"a", "e"}, {"b", "d"}, {"c", "f"}]
    |> Stream.zip()
    |> Stream.map(&(frequent(&1, fun)))
    |> Enum.join("")
  end

  # O(N)
  def frequent(tuple, fun) do
    tuple
    |> Tuple.to_list()
    |> Enum.reduce(%{}, fn(element, acc) ->
      Map.update(acc, element, 0, &(&1 + 1))
    end)
    |> fun.()
    |> elem(0)
  end

  def normalize_line(data, pattern) do
    String.split(data, pattern, trim: true)
  end
end
