defmodule AOC17.Day22 do
  @matrix File.read!("data/2017/day22.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
    |> Matrix.from_list()

  # 12.85s
  def run() do
    {x, y} = start()
    m = @matrix
    process(m, {x, y}, {0, -1}, m[y][x], {0, 0})
  end

  def process(_m, _, _d, _v, {inf, 10000000}), do: inf
  def process(m, cor, d, ".", {inf, acc}) do
    args = move(m, cor, d, "w", "l") ++ [{inf, acc + 1}]
    apply(__MODULE__, :process, args)
  end
  def process(m, cor, d, "#", {inf, acc}) do
    args = move(m, cor, d, "f", "r") ++ [{inf, acc + 1}]
    apply(__MODULE__, :process, args)
  end
  def process(m, cor, d, "w", {inf, acc}) do
    args = move(m, cor, d, "#", "n") ++ [{inf + 1, acc + 1}]
    apply(__MODULE__, :process, args)
  end
  def process(m, cor, d, "f", {inf, acc}) do
    args = move(m, cor, d, ".", "s") ++ [{inf, acc + 1}]
    apply(__MODULE__, :process, args)
  end

  defp move(m, {x, y}, d, v, turn) do
    m = Map.update(m, y, %{}, &(&1)) |> put_in([y, x], v)
    {dx, dy} = turn(d, turn)
    x = x + dx
    y = y + dy
    [m, {x, y}, {dx, dy}, m[y][x] || "."]
  end

  defp start(), do: {div(map_size(@matrix), 2), div(map_size(@matrix[0]), 2)}

  defp turn({-1, 0}, "r"), do: {0, -1}
  defp turn({-1, 0}, "l"), do: {0, 1}
  defp turn({-1, 0}, "s"), do: {1, 0}
  defp turn({0, 1}, "r"), do: {-1, 0}
  defp turn({0, 1}, "l"), do: {1, 0}
  defp turn({0, 1}, "s"), do: {0, -1}
  defp turn({1, 0}, "r"), do: {0, 1}
  defp turn({1, 0}, "l"), do: {0, -1}
  defp turn({1, 0}, "s"), do: {-1, 0}
  defp turn({0, -1}, "r"), do: {1, 0}
  defp turn({0, -1}, "l"), do: {-1, 0}
  defp turn({0, -1}, "s"), do: {0, 1}
  defp turn(d, "n"), do: d
end
