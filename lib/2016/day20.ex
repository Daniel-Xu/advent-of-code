defmodule Day20 do
  use Utils

  def part_one(file \\ "data/day20.txt") do
    generate_state(file)
    |> process(0)
  end

  def part_two(file \\ "data/day20.txt", boundary \\ 4294967295) do
    generate_state(file)
    |> run(0, 0, boundary)
  end

  def generate_state(name) do
    normalize_file(name, "-")
    |> Enum.to_list
    |> Enum.sort()
  end

  def process([{s, e} | t], n) when n in s..e,
    do: process(t, e + 1)
  def process([{_s, e} | t], n) when n > e, do: process(t, n)
  def process(_list, n), do: n

  def run([], n, allowed, boundary), do: boundary - n + 1 + allowed
  def run([{s, e} | t], n, allowed, boundary) when n in s..e,
    do: run(t, e + 1, allowed, boundary)
  def run([{_s, e} | t], n, allowed, boundary) when n > e,
    do: run(t, n, allowed, boundary)
  def run([{s, e} | t], n, allowed, boundary), do: run(t, e + 1, s - n + allowed, boundary)

  def normalize_line(data, pattern) do
    String.split(data, pattern, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end
end
