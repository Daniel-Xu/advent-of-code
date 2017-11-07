defmodule Day12 do
  use Utils
  def part_one(name \\ "data/day12.txt"), do: handle(name)
  def part_two(name \\ "data/day12.txt"), do: handle(name, %{"a" => 0, "b" => 0, "c" => 1, "d" => 0})

  def handle(name, state \\ %{"a" => 0, "b" => 0, "c" => 0, "d" => 0}) do
    cmds =
      normalize_file(name)
      |> Stream.map(&normalize_command/1)
      |> Enum.with_index()

    process({cmds, cmds}, state)
  end

  def process({[], _cmds}, state), do: state
  def process({[{{:copy, n, reg}, _index} | t], cmds}, state) when is_integer(n),
    do: process({t, cmds}, Map.put(state, reg, n))
  def process({[{{:copy, n, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.put(state, reg, Map.get(state, n)))
  def process({[{{:inc, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.update(state, reg, 1, &(&1 + 1)))
  def process({[{{:dec, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.update(state, reg, 1, &(&1 - 1)))
  def process({[{{:jnz, {:reg, reg_name}, step}, index} | t], cmds}, state),
    do: process({[{{:jnz, Map.get(state, reg_name), step}, index} | t], cmds}, state)
  def process({[{{:jnz, n, _step}, _index} | t], cmds}, state) when n == 0 do
    process({t, cmds}, state)
  end
  def process({[{{:jnz, _n, step}, index} | _t], cmds}, state) do
    {_, current_cmds} = Enum.split(cmds, step + index)
    process({current_cmds, cmds}, state)
  end

  @doc """
  Command parser
  """
  def normalize_line(data, pattern), do: String.split(data, pattern, trim: true)

  defp normalize_command(["cpy" | [x, reg]]) do
    if Regex.match?(~r/\d+/, x) do
      {:copy, String.to_integer(x), reg}
    else
      {:copy, x, reg}
    end
  end
  defp normalize_command(["inc", reg]), do: {:inc, reg}
  defp normalize_command(["dec", reg]), do: {:dec, reg}
  defp normalize_command(["jnz" | [reg, step]]) do
    if Regex.match?(~r/\d+/, reg) do
      {:jnz, String.to_integer(reg), String.to_integer(step)}
    else
      {:jnz, {:reg, reg}, String.to_integer(step)}
    end
  end
end
