defmodule AOC17.Day9 do
  use Utils

  def part_one()  do
    input()
    |> String.replace(~r/!.+?/, "")
    |> String.replace(~r/<.*?>/, "")
    |> score(0, 0)
  end

  # I found an Elixir bug for the Regex lookbehind and lookahead
  def part_two() do
    input() |> characters()
  end

  defp input(name \\ "data/2017/day9.txt") do
    normalize_file(name)
    |> Enum.to_list()
    |> hd()
  end

  defp characters(s) do
    s = String.replace(s, ~r/!.+?/, "")
    j = Regex.scan(~r/<.*?>/, s)
    Enum.reduce(j, 0, fn([r], acc) -> byte_size(r) + acc end) - Enum.count(j) * 2
  end

  def score(<<>>, _n, acc), do: acc
  def score(<<?{, t::binary>>, n, acc) do
    n = n + 1
    score(t, n, acc + n)
  end
  def score(<<?,, t::binary>>, n, acc), do: score(t, n, acc)
  def score(<<?}, t::binary>>, n, acc), do: score(t, n - 1, acc)

  def normalize_line(data, _pattern), do: data
end
