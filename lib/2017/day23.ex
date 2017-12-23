defmodule AOC17.Day23 do
  @cmds File.read!("data/2017/day23.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)

  def part_one(), do: run_cmd([%{"a" => 0}, 0])

  @doc """
  [%{"a" => 1, "b" => 109900, "c" => 126900, "d" => 4, "e" => 59348, "f" => 0,
      "g" => -50552, "mul" => 279143}, 11]

  while c != b
    -> b += 17

  if f = 0:
    -> h = h + 1

  d = e = 2
  if d * e == b
    -> f = 0
  else
    -> e + 1
  """
  def part_two() do
    n = div(126900 - 109900, 17) + 1
    Enum.reduce(1..n, {109900, 0}, fn(_n, {b, acc}) ->
      acc = if prime_n?(b), do: acc, else: acc + 1
      {b + 17, acc}
    end)
  end

  defp prime_n?(x) do
    Enum.reduce_while(2..div(x, 2), true, fn(d, acc) ->
      if rem(x, d) == 0, do: {:halt, false}, else: {:cont, acc}
    end)
  end

  def run_cmd([%{"stop" => true} = state, _i]), do: state
  def run_cmd([p0, i]) when i < 0 or i >= length(@cmds), do: [Map.put(p0, "stop", true), i]
  def run_cmd([_p0, i] = ins) do
    [cmd | args] = cmds() |> Enum.at(i)
    cmd = String.to_existing_atom(cmd)

    apply(__MODULE__, cmd, ins ++ args) |> run_cmd()
  end

  def set(p0, i, a, b),
    do: [Map.put(p0, a, get_v(p0, b)), i + 1]
  def mul(p0, i, a, b),
    do: [Map.update(p0, a, 0, &(&1 * get_v(p0, b))) |> Map.update("mul", 1, &(&1 + 1)), i + 1]
  def sub(p0, i, a, b),
    do: [Map.update(p0, a, 0, &(&1 - get_v(p0, b))), i + 1]
  def jnz(p0, i, a, b) do
    case get_v(p0, a) != 0 do
      true ->
        [p0, i + get_v(p0, b)]
      false ->
        [p0, i + 1]
    end
  end

  defp get_v(p, x) do
    if Regex.match?(~r/\d+/, x),
      do: String.to_integer(x),
      else: Map.get(p, x, 0)
  end

  defp cmds(), do: @cmds
end
