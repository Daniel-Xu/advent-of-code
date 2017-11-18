defmodule Day18 do
  @first_row ".^^..^...^..^^.^^^.^^^.^^^^^^.^.^^^^.^^.^^^^^^.^...^......^...^^^..^^^.....^^^^^^^^^....^^...^^^^..^"
  @len byte_size(@first_row)

  def part_one() do
    first_row = parse(%{}, @first_row, 0)
    acc = Enum.reduce(first_row, 0, fn({_k, v}, acc) ->
      if v == true, do: acc + 1, else: acc
    end)

    process(first_row, 1, acc)
  end

  def process(_row_p, 400000, acc), do: acc
  def process(row_p, n, acc) do
    {row, acc} =
      Enum.reduce(0..@len-1, {%{}, acc}, fn(n, {row, acc}) ->
        is_trap = trap?(row_p, n)
        acc = if is_trap, do: acc, else: acc + 1
        {Map.put(row, n, !is_trap), acc}
      end)
    process(row, n + 1, acc)
  end

  def trap?(row_p, n) do
    left_safe = Map.get(row_p, n - 1, true)
    right_safe = Map.get(row_p, n + 1, true)

    (not left_safe)  and right_safe or
    (not right_safe) and left_safe or
    (not left_safe)  and right_safe or
    (not right_safe) and left_safe
  end

  @doc """
  true -> safe
  false -> trap
  """
  def parse(state, <<>>, _n), do: state
  def parse(state, <<".", t::binary>>, n),
    do: Map.put(state, n, true) |> parse(t, n + 1)
  def parse(state, <<"^", t::binary>>, n),
    do: Map.put(state, n, false) |> parse(t, n + 1)

  def first() do
    @first_row
  end
end
