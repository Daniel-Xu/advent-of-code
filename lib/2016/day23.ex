defmodule Day23 do
  use Utils
  @doc """
  part_two, manually calculated
  %{"a" => 132, "b" => 10, "c" => 20, "d" => 0}
  %{"a" => 1320, "b" => 9, "c" => 18, "d" => 0}
  %{"a" => 11880, "b" => 8, "c" => 16, "d" => 0}
  %{"a" => 95040, "b" => 7, "c" => 14, "d" => 0}
  %{"a" => 665280, "b" => 6, "c" => 12, "d" => 0}
  %{"a" => 3991680, "b" => 5, "c" => 10, "d" => 0}
  %{"a" => 19958400, "b" => 4, "c" => 8, "d" => 0}
  ...
  6720 + 12! -> result
  """
  def part_one(name \\ "data/day23.txt"), do: handle(name)
  def handle(name, state \\ %{"a" => 12, "b" => 0, "c" => 0, "d" => 0}) do
    cmds =
      normalize_file(name)
      |> Stream.map(&normalize_command/1)
      |> Enum.with_index()

    process({cmds, cmds}, state)
  end

  def process({[], _cmds}, state), do: state
  # cpy --------------------------
  def process({[{{:copy, n, reg}, _index} | t], cmds}, state) when is_integer(n),
    do: process({t, cmds}, Map.put(state, reg, n))
  def process({[{{:copy, n, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.put(state, reg, Map.get(state, n)))
  # inc dec --------------------------
  def process({[{{:inc, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.update(state, reg, 1, &(&1 + 1)))
  def process({[{{:dec, reg}, _index} | t], cmds}, state),
    do: process({t, cmds}, Map.update(state, reg, 1, &(&1 - 1)))
  # jnz --------------------------
  def process({[{{:jnz, {:reg, reg_name}, step}, index} | t], cmds}, state),
    do: process({[{{:jnz, Map.get(state, reg_name), step}, index} | t], cmds}, state)
  def process({[{{:jnz, n, {:reg, reg_name}}, index} | t], cmds}, state),
    do: process({[{{:jnz, n, Map.get(state, reg_name)}, index} | t], cmds}, state)
  def process({[{{:jnz, {:reg, x}, {:reg, y}}, index} | t], cmds}, state),
    do: process({[{{:jnz, Map.get(state, x), Map.get(state, y)}, index} | t], cmds}, state)
  def process({[{{:jnz, n, _step}, _index} | t], cmds}, state) when n == 0 do
    process({t, cmds}, state)
  end
  def process({[{{:jnz, _n, step}, index} | _t], cmds}, state) do
    {_, current_cmds} = Enum.split(cmds, step + index)
    process({current_cmds, cmds}, state)
  end
  # tgl --------------------------
  def process({[{{:tgl, reg}, index} | t], cmds}, state) do
    step = Map.get(state, reg) + index
    if step >= 0 and step < Enum.count(cmds) do
      cmd = Enum.at(cmds, step) |> elem(0)
      cmds = List.update_at(cmds, step, fn(_) ->
        {do_toggle(cmd), step}
      end)

      {_, current_cmds} = Enum.split(cmds, index + 1)
      process({current_cmds, cmds}, state)
    else
      process({t, cmds}, state)
    end
  end
  def process({[{_cmd, _index} | t], cmds}, state), do: process({t, cmds}, state)

  defp do_toggle({:inc, reg}), do: {:dec, reg}
  defp do_toggle({:dec, reg}), do: {:inc, reg}
  defp do_toggle({:tgl, reg}), do: {:inc, reg}
  defp do_toggle({:jnz, n, {:reg, reg}}), do: {:copy, n, reg}
  defp do_toggle({:jnz, {:reg, x}, {:reg, y}}), do: {:copy, x, y}
  defp do_toggle({:jnz, _, _}), do: {:invalide}
  defp do_toggle({:copy, n, reg}) when is_integer(n), do: {:jnz, n, {:reg, reg}}
  defp do_toggle({:copy, x, y}), do: {:jnz, {:reg, x}, {:reg, y}}

  @doc """
  parser
  """
  def normalize_line(data, pattern), do: String.split(data, pattern, trim: true)

  defp normalize_command(["cpy" | [x, reg]]) do
    if Regex.match?(~r/\d+/, x) do
      {:copy, String.to_integer(x), reg}
    else
      {:copy, x, reg}
    end
  end
  defp normalize_command(["tgl", reg]), do: {:tgl, reg}
  defp normalize_command(["inc", reg]), do: {:inc, reg}
  defp normalize_command(["dec", reg]), do: {:dec, reg}
  defp normalize_command(["jnz" | [reg, step]]) do
    reg = if Regex.match?(~r/\d+/, reg), do: String.to_integer(reg), else: {:reg, reg}
    step = if Regex.match?(~r/\d+/, step), do: String.to_integer(step), else: {:reg, step}

    {:jnz, reg, step}
  end
end
