defmodule Day25 do
  use Utils
  require Integer

  @doc """
  n = 0..x
  next_a = 1270 + n / 2
  b = is_even(a) ? 1 : 0
  next_b = next_a % 2
  """
  def part_one(n, _a, _b = nil, keep_going) do
    b = if Integer.is_even(n), do: 1, else: 0
    part_one(n, 1270 + round(n/2), b, keep_going)
  end
  def part_one(n, 0, _b, _keep_going), do: n
  def part_one(n, _a, _b, false), do: part_one(n + 1, n + 1, nil, true)
  def part_one(n, a, b, true) do
    next_b = rem(a, 2)
    keep_going = if b + next_b == 1, do: true, else: false

    part_one(n, div(a, 2), next_b, keep_going)
  end

  def experiment(name \\ "data/day25.txt") do
    for x <- 0..100 do
      state = %{"a" => x, "b" => 0, "c" => 0, "d" => 0}
      {x, handle(name, state)}
    end
  end

  def handle(name, state \\ %{"a" => 7, "b" => 0, "c" => 0, "d" => 0}) do
    cmds =
      normalize_file(name)
      |> Stream.map(&normalize_command/1)
      |> Enum.with_index()

    process({cmds, cmds}, state)
  end

  def process({[], _cmds}, state), do: state

  def process({[{{:out, {:reg, reg}}, index} | t], cmds}, state),
    do: process({[{{:out, Map.get(state, reg)}, index} | t], cmds}, state)
  def process({[{{:out, n}, _index} | t], cmds}, state) do
    IO.inspect n
    IO.inspect state
    process({t, cmds}, state)
  end
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
  defp normalize_command(["out", reg]) do
    if Regex.match?(~r/\d+/, reg), do: {:out, String.to_integer(reg)}, else: {:out, {:reg, reg}}
  end
end
