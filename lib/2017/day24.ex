defmodule AOC17.Day24 do
  @input File.read!("data/2017/day24.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(fn(l) ->
      String.split(l, "/") |> Enum.map(&String.to_integer/1)
    end)

  def state() do
    @input
    |> Enum.flat_map(&(&1))
    |> Enum.uniq()
    |> Enum.reduce(%{}, fn(n, m) ->
      Map.put(m, n, Enum.filter(@input, fn(x) -> n in x end))
    end)
  end

  def run() do
    s = state()

    Enum.map(s[0], fn(x) ->
      process(x, s, MapSet.new([x]), 0, Enum.sum(x), 0)
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
  end

  def process(start, state, m, n, acc, len) do
    m = MapSet.put(m, start)
    b = part(start, n)
    connected = connected(state, b, m)
    if connected == [] do
      {acc, len}
    else
      connected
      |> Enum.map(fn(c) ->
        process(c, state, m, b, acc + Enum.sum(c), len + 1)
      end)
      |> Enum.sort_by(&elem(&1, 0), &>=/2)
      |> Enum.max_by(&elem(&1, 1)) # change 1 to 0 for part_one
    end
  end

  def connected(state, n, m),
    do: state[n] |> Enum.reject(&MapSet.member?(m, &1))

  def part(x, n), do: (x -- [n]) |> hd()
end
