defmodule Day16 do
  use Bitwise
  require Integer

  @i <<0b10010000000110000::17>>
  @len 272
  @len_l 35651584

  def part_one(), do: data(@i, @len) |> check_sum()
  def part_two(), do: data(@i, @len_l) |> check_sum()

  def check_sum(s, acc \\ <<>>)
  def check_sum(<<>>, acc) when Integer.is_odd(bit_size(acc)), do: acc
  def check_sum(<<>>, acc), do: check_sum(acc, <<>>)
  def check_sum(<<a::size(1), b::size(1), t::bits>>, acc) when a == b, do: check_sum(t, <<acc::bits, 1::size(1)>>)
  def check_sum(<<_a::size(1), _b::size(1), t::bits>>, acc), do: check_sum(t, <<acc::bits, 0::size(1)>>)

  @doc """
  f(a) = b
  f(f(a)) == a
  f(a 0 b) == f(b) f(0) f(a) == a 1 b
  f(a 0 b 0 a 1 b) = f(b) 0 f(a) 1 f(b) 1 f(a) = a 0 b 1 a 1 b

  a 0 b
  a 1 b

  a 0 b 0 a 1 b
  a 0 b 1 a 1 b

  a 0 b 0 a 1 b 0 a 0 b 1 a 1 b
  a 0 b 0 a 1 b 1 a 0 b 1 a 1 b

  a
  a 0 b
  a 0 b 0 a 1 b
  a 0 b 0 a 1 b 0 a 0 b 1 a 1 b
  a 0 b 0 a 1 b 0 a 0 b 1 a 1 b 0 a 0 b 0 a 1 b 1 a 0 b 1 a 1 b

  0 0 1 0 0 1 1 0 0 0 1 1 0 1 1 -> this is dragon curve
  we can calculate the dragon curver bit directly

  a + b + 1 => 17 * 2 + 2
  [0, 1] [2, 3], [3, 4]
  """
  def data(a \\ @i, len \\ @len_l) do
    b = reverse_neg(a)
    n = div(len, 17 * 2 + 2)

    <<d::bits-size(len), _t::bits>> =
      Enum.chunk_every(0..n*2, 2, 2, [n * 2 + 1])
      |> Enum.reduce(<<>>, fn([f, s], acc) ->
        <<acc::bits, a::bits, dragon_bits(f)::1, b::bits, dragon_bits(s)::1>>
    end)
    <<d::bits-size(len)>>
  end

  @doc """
  0 0 1 0 0 1 1 0 0 0 1 1 0 1 1
  0 1 2 3 4 5 6 7 8 9 10

  n is even: 0, 1 every 2 elements => div(n, 2) &&& 1
  n is odd: we need to keep div(n, 2) until n is even, then div(n, 2) &&& 1
  that means: we need to find the right most 0.

  011 => 100
  ^
  n + 1 will turn the rightmost 0 to 1, and all the 1 to the right to be 0
  """
  def dragon_bits(n) do
    div(n, ((n + 1) ^^^ n) + 1) &&& 1
  end

  def reverse_neg(<<>>), do: <<>>
  def reverse_neg(<<h::size(1), t::bits>>), do: <<reverse_neg(t)::bits, (1 ^^^ h)::size(1)>>
end
