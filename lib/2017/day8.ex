defmodule AOC17.Day8 do
  use Utils
  @doc """
  iex(8)> AOC17.Day8.handle
  {4448, 6582}
  """
  def handle(name \\ "data/2017/day8.txt")  do
    normalize_file(name, " if ")
    |> Enum.to_list()
    |> process(%{}, 0)
  end

  def process([], state, max), do: {map_max(state), max}
  def process([{[reg, "dec", n], condition} | t], state, max) do
    reg_v = Map.get(state, reg, 0)
    reg_v = if valid?(condition, state), do: reg_v - n, else: reg_v
    process(t, Map.put(state, reg, reg_v), Enum.max([reg_v, max]))
  end
  def process([{[reg, "inc", n], condition} | t], state, max) do
    reg_v = Map.get(state, reg, 0)
    reg_v = if valid?(condition, state), do: reg_v + n, else: reg_v
    process(t, Map.put(state, reg, reg_v), Enum.max([reg_v, max]))
  end

  def normalize_line(data, pattern) do
    [cmd, condition] = String.split(data, pattern, trim: true)
    [reg_a, operation_a, n_a] = String.split(cmd, " ")
    [reg_b, operation_b, n_b] = String.split(condition, " ")

    {[reg_a, operation_a, String.to_integer(n_a)], [reg_b, operation_b, String.to_integer(n_b)]}
  end

  defp map_max(m), do: Map.values(m) |> Enum.max()

  defp valid?([reg, "<",  n], state), do: Map.get(state, reg, 0) <  n
  defp valid?([reg, "<=", n], state), do: Map.get(state, reg, 0) <= n
  defp valid?([reg, ">",  n], state), do: Map.get(state, reg, 0) >  n
  defp valid?([reg, ">=", n], state), do: Map.get(state, reg, 0) >= n
  defp valid?([reg, "==", n], state), do: Map.get(state, reg, 0) == n
  defp valid?([reg, "!=", n], state), do: Map.get(state, reg, 0) != n
end
