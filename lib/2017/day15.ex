defmodule AOC17.Day15 do
  @a 116
  @b 299

  use Bitwise

  @doc """
  part two
  part one is similar and simpler, no need to repeat it here
  """
  def process(a \\ @a, b \\ @b, n \\ 0, acc \\ 0)
  def process(_a, _b, 5_000_000, acc), do: acc
  def process(a, b, n, acc) do
    # uncomment for part_one, dont forget to change the 5_000_000 to 40_000_000
    # next_a = rem(a * 16807, 2147483647)
    # next_b = rem(b * 48271, 2147483647)
    next_a = next_a(a, a)
    next_b = next_b(b, b)

    mask = (1 <<< 16) - 1
    acc = if (next_a &&& mask) ^^^ (next_b &&& mask) == 0, do: acc + 1, else: acc

    process(next_a, next_b, n + 1, acc)
  end

  def next_a(a, prev) when a != prev and rem(a, 4) == 0, do: a
  def next_a(a, prev), do: rem(a * 16807, 2147483647) |> next_a(prev)

  def next_b(b, prev) when b != prev and rem(b, 8) == 0, do: b
  def next_b(b, prev), do: rem(b * 48271, 2147483647) |> next_b(prev)
end
