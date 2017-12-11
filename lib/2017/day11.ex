defmodule AOC17.Day11 do

  def handle(name \\ "data/2017/day11.txt")  do
    File.read!(name)
    |> String.trim()
    |> String.split(",")
    |> process({0, 0}, 0)
  end

  def process([], {x, y} = c, n), do: {abs(x) + abs(y), max_n(c, n)}
  def process(["n" | t], {x, y} = c, n), do: process(t, {x, y + 1}, max_n(c, n))
  def process(["nw" | t], {x, y} = c, n), do: process(t, {x - 0.5, y + 0.5}, max_n(c, n))
  def process(["ne" | t], {x, y} = c, n), do: process(t, {x + 0.5, y + 0.5}, max_n(c, n))
  def process(["s" | t], {x, y} = c, n), do: process(t, {x, y - 1}, max_n(c, n))
  def process(["sw" | t], {x, y} = c, n), do: process(t, {x - 0.5, y - 0.5}, max_n(c, n))
  def process(["se" | t], {x, y} = c, n), do: process(t, {x + 0.5, y - 0.5}, max_n(c, n))

  defp max_n({x, y}, n), do: Enum.max([abs(x) + abs(y), n])
end
