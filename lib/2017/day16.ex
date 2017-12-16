defmodule AOC17.Day16 do
  use Utils

  @doc """
  I used List for the first time, but then changed to Map
  However, 1 billion times is impossible even with Map,
  so I knew there must be cycles
  """
  def state() do
    (for x <- ?a..?p, do: <<x :: utf8>>)
    |> Enum.with_index()
    |> Enum.map(fn({k, v}) -> {v, k} end)
    |> Enum.into(%{})
  end

  def run_once(cmds, l) do
    Enum.reduce(cmds, l, fn({name, args}, l) ->
      apply(__MODULE__, name, [l | args])
    end)
  end

  def part_one(), do: process(handle(), state(), 1, 0)
  def part_two() do
    cmds = handle()
    l = state()
    n = cycle_n(cmds, l, 0)
    n = rem(1_000_000_000, n)
    process(cmds, l, n, 0)
  end

  def process(_cmds, l, n, acc) when n == acc, do: l |> Map.values() |> Enum.join("")
  def process(cmds, l, n, acc), do: process(cmds, run_once(cmds, l), n, acc + 1)

  def cycle_n(cmds, l, n) do
    s = %{0 => "a", 1 => "b", 2 => "c", 3 => "d", 4 => "e", 5 => "f", 6 => "g",
          7 => "h", 8 => "i", 9 => "j", 10 => "k", 11 => "l", 12 => "m", 13 => "n",
          14 => "o", 15 => "p"}

    if s == l && n > 0 do
      n
    else
      cycle_n(cmds, run_once(cmds, l), n + 1)
    end
  end

  def spin(l, n) do
    len = map_size(l)
    Enum.map(l, fn({i, x}) ->
      m = len - n
      if i < m, do: {i + n, x}, else: {i - m, x}
    end)
    |> Enum.into(%{})
  end

  def exc(l, i, j) do
    Map.update!(l, i, fn(_) -> Map.get(l, j) end)
    |> Map.update!(j, fn(_) -> Map.get(l, i) end)
  end

  def par(l, a, b) do
    i = Enum.find(l, fn({_n, x}) -> x == a end) |> elem(0)
    j = Enum.find(l, fn({_n, x}) -> x == b end) |> elem(0)
    exc(l, i, j)
  end

  def handle(name \\ "data/2017/day16.txt")  do
    normalize_file(name, ",")
    |> Enum.to_list()
    |> hd()
    |> Enum.map(&normalize_cmd/1)
  end

  def normalize_line(data, pattern), do: String.split(data, pattern)

  def normalize_cmd("s"<> n), do: {:spin, [String.to_integer(n)]}
  def normalize_cmd(<<"x", t::binary>>), do: {:exc, String.split(t, "/") |> Enum.map(&String.to_integer/1)}
  def normalize_cmd(<<"p", t::binary>>), do: {:par, String.split(t, "/")}
end
