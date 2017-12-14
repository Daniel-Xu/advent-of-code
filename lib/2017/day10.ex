defmodule AOC17.Day10 do
  import Bitwise
  @input "192,69,168,160,78,1,166,28,0,83,198,2,254,255,41,12"
  @size 256

  def handle(), do: String.split(@input, ",") |> Enum.map(&String.to_integer/1)
  def handle_s(i \\ @input), do: (for << x <- i>>, do: x) ++ [17, 31, 73, 47, 23]

  def part_one() do
    Enum.to_list(0..255)
    |> process(@size, handle(), 0, 0)
    |> Enum.reduce(&Kernel.*/2)
  end

  def part_two(i) do
    l = Enum.to_list(0..255)
    input = handle_s(i)

    {_, _, l} =
      Stream.scan(1..64, {0, 0, l}, fn(_n, {c, s, l}) ->
        process(l, @size, input, c, s)
      end)
      |> Enum.to_list()
      |> List.last()

    Enum.chunk_every(l, 16)
    |> Enum.map(fn(c) ->
      Enum.reduce(c, fn(n, acc) -> n ^^^ acc end)
      |> :binary.encode_unsigned()
      |> Base.encode16(case: :lower)
    end)
    |> Enum.join("")
  end

  @doc """
  rotate right (len - current)
  reverse
  rotate back
  """
  # def process(l, _len, [], _c, _s), do: Enum.slice(l, 0..1) #for part_one
  def process(l, _len, [], c, s), do: {c, s, l}
  def process(l, len, [0 | i_t], c, s), do: process(l, len, i_t, rem(c + s, len), s + 1)
  def process(l, len, [i_h | i_t], c, s) do
    step = len - c
    {l_s, l_e} = rotate_right(l, step) |> Enum.split(i_h)
    l = Enum.reverse(l_s) ++ l_e |> rotate_left(step)

    process(l, len, i_t, rem(c + i_h + s, len), s + 1)
  end

  defp rotate_left(l, n) do
    len = Enum.count(l)
    {h, t} = Enum.split(l, rem(n, len))
    t ++ h
  end

  defp rotate_right(l, n) do
    len = Enum.count(l)
    {h, t} = Enum.split(l, rem(len - n, len))
    t ++ h
  end
end
