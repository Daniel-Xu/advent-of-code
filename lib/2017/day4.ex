defmodule AOC17.Day4 do
  use Utils

  def part_one(name \\ "data/2017/day4.txt") do
    handle(name, fn(line) ->
      combination(line) |> Enum.any?(fn({a, b}) -> a == b end)
    end)
    |> Enum.sum()
  end

  def part_two(name \\ "data/2017/day4.txt") do
    handle(name, fn(line) ->
      combination(line) |> Enum.any?(&anagrams?(elem(&1, 0), elem(&1, 1)))
    end)
    |> Enum.sum()
  end

  def handle(name, func)  do
    normalize_file(name)
    |> Stream.transform(func, fn
      line, func ->
        v = if func.(line), do: 0, else: 1
        {[v], func}
    end)
  end

  def anagrams?(a, b) do
    sorted_chars(a) == sorted_chars(b)
  end

  defp sorted_chars(s) do
    String.split(s, "") |> Enum.sort()
  end

  defp combination(l, acc \\ [])
  defp combination([], acc), do: acc
  defp combination([h | t], acc) do
    combo = for a <- t, do: {h, a}
    combination(t, combo ++ acc)
  end

  def normalize_line(data, pattern), do: String.split(data, pattern, trim: true)
end
