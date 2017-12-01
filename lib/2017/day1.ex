defmodule AOC17.Day1 do
  def part_one() do
    input() |> process(?2, 0)
  end

  def part_two() do
    s = input()
    len = byte_size(s)
    step = div(len, 2)
    l = String.split(s, "")

    Enum.with_index(l)
    |> Enum.reduce(0, fn({n, i}, acc) ->
      next_i = if i + step >= len, do: i + step - len, else: i + step
      if Enum.at(l, next_i) == n, do: acc + String.to_integer(n), else: acc
    end)
  end

  def input(path \\ "data/17_day1.txt") do
    File.read!(path) |> String.trim()
  end

  def process(<<l>>, l, acc), do: acc + (l - ?0)
  def process(<<_>>, _, acc), do: acc
  def process(<<h, h, t::binary>>, first, acc),
    do: process(<<h, t::binary>>, first, acc + (h - ?0))
  def process(<<f, s, t::binary>>, first, acc),
    do: process(<<s, t::binary>>, first, acc)
end
