defmodule AOC17.Day18 do
  @cmds File.read!("data/2017/day18.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)

  def part_two(), do: process()

  def snd(p0, p1, i, x) do
    v = get_v(p0, x)
    [Map.update(p0, "send", 1, &(&1 + 1)), Map.update(p1, "msgs", [v], &(&1 ++ [v])), i + 1]
  end
  def set(p0, p1, i, a, b),
    do: [Map.put(p0, a, get_v(p0, b)), p1, i + 1]
  def add(p0, p1, i, a, b),
    do: [Map.update(p0, a, 0, &(&1 + get_v(p0, b))), p1, i + 1]
  def mul(p0, p1, i, a, b),
    do: [Map.update(p0, a, 0, &(&1 * get_v(p0, b))), p1, i + 1]
  def mod(p0, p1, i, a, b),
    do: [Map.update(p0, a, 0, &rem(&1, get_v(p0, b))), p1, i + 1]
  def rcv(p0, p1, i, x) do
    case Map.get(p0, "msgs", []) do
      [] ->
        [Map.put(p0, "retry", true), p1, i]
      [v | t] ->
        [Map.merge(p0, %{x => v, "retry" => false, "msgs" => t}), p1, i + 1]
    end
  end
  def jgz(p0, p1, i, a, b) do
    case get_v(p0, a) > 0 do
      true ->
        [p0, p1, i + get_v(p0, b)]
      false ->
        [p0, p1, i + 1]
    end
  end

  @doc """
  stop => return
  retry => try again
  """
  def run_cmd([%{"stop" => true}, _p1, _i] = ins), do: ins
  def run_cmd([p0, p1, i]) when i < 0 or i >= length(@cmds) do
    [%{p0 | "stop" => true}, p1, i]
  end
  def run_cmd([_p0, _p1, i] = ins) do
    [cmd | args] = cmds() |> Enum.at(i)
    cmd = String.to_existing_atom(cmd)

    apply(__MODULE__, cmd, ins ++ args)
  end

  def process(p0 \\ [%{"p" => 0}, 0], p1 \\ [%{"p" => 1}, 0])
  def process([%{"retry" => true}, _p0_i], [%{"retry" => true} = p1 , _p1_i]),
    do: Map.get(p1, "send")
  def process([%{"stop" => true}, _p0_i], [%{"stop" => true} = p1 , _p1_i]),
    do: Map.get(p1, "send")
  def process([p0, p0_i], [p1, p1_i]) do
    [p0, p1, p0_i] = run_cmd([p0, p1, p0_i])
    [p1, p0, p1_i] = run_cmd([p1, p0, p1_i])

    process([p0, p0_i], [p1, p1_i])
  end

  defp get_v(p, x) do
    if Regex.match?(~r/\d+/, x),
      do: String.to_integer(x),
      else: Map.get(p, x, 0)
  end

  defp cmds(), do: @cmds
end
