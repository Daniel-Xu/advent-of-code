defmodule AOC17.Day14 do
  @input "oundnydw"

  def state(input \\ @input) do
    Enum.map(0..127, fn(x) ->
      hash =
        AOC17.Day10.part_two("#{input}-#{x}")
        |> Base.decode16!(case: :lower)
      for <<b::size(1) <- hash>>, do: b
    end)
  end

  def part_one()  do
    state = state()
    Enum.reduce(state, 0, &(Enum.sum(&1) + &2))
  end

  def part_two() do
    g = grid()
    Enum.reduce(g, {0, MapSet.new()}, fn({cor, _}, {n, v}) ->
      if MapSet.member?(v, cor),
        do: {n, v},
        else: {n + 1, process(g, cor, v)}
    end)
    |> elem(0)
  end

  def process(g, cor, visited) do
    visited = MapSet.put(visited, cor)
    adjacents(cor, g)
    |> Enum.reduce(visited, fn(adj, v) ->
      if MapSet.member?(v, adj),
        do: v,
        else: process(g, adj, v)
    end)
  end

  def adjacents({x, y}, g) do
    [{x, y + 1}, {x, y - 1}, {x + 1, y}, {x - 1, y}]
    |> Enum.filter(&valid?(&1, g))
  end

  defp valid?({x, y}, _g) when x < 0 or y < 0 or x > 127 or y > 127, do: false
  defp valid?(cor, g), do: Map.get(g, cor) == true

  defp grid() do
    state = state() |> Enum.with_index()

    Enum.reduce(state, %{}, fn({str, x}, m) ->
      to_cors(str, m, x)
    end)
  end

  defp to_cors(l, m, x, y \\ 0)
  defp to_cors([], m, _x, _y), do: m
  defp to_cors([1 | t], m, x, y), do: to_cors(t, Map.put(m, {x, y}, true), x, y + 1)
  defp to_cors([_ | t], m, x, y), do: to_cors(t, m, x, y + 1)
end
