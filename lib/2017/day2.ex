defmodule AOC17.Day2 do
  use Utils
  def part_one(name \\ "data/17_day2.txt") do
    normalize_file(name, "\t")
    |> Enum.reduce(0, fn(row, acc) ->
      Enum.max(row) - Enum.min(row) + acc
    end)
  end

  def part_two(name \\ "data/17_day2.txt") do
    normalize_file(name, "\t")
    |> Enum.reduce(0, fn(row, acc) ->
      [{a, b}] = for a <- row, b <- row, a != b, rem(b, a) == 0, do: {a, b}
      div(b, a) + acc
    end)
  end

  def normalize_line(data, pattern) do
    String.split(data, pattern, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
