defmodule Day5 do
  def main do
    crack("abbhdwsy")
  end

  def crack(input) do
    Stream.unfold(0, fn(n) ->
      {:crypto.hash(:md5, "#{input}#{n}"), n + 1}
    end)
    |> Stream.filter(&filter/1)
    # 00000000 00000000 0000 0PPP PPPP____
    # 00       00       0P  C_
    # encode16 -> postion password -> string
    |> Stream.map(fn(<<_::size(16), code::binary-size(2), _rest::binary>>) ->
      <<_, position::binary-size(1), password::binary-size(1), _>> = Base.encode16(code, case: :lower)
      {String.to_integer(position), password}
    end)
    |> Enum.reduce_while(%{}, fn({position, password}, acc) ->
      IO.inspect acc
      if map_size(acc) == 8, do: {:halt, acc}, else: {:cont, Map.put_new(acc, position, password)}
    end)
    |> Map.values()
    |> Enum.join("")
  end

  def filter(<<0::size(21), _::bitstring>>), do: true
  def filter(_invalid_hash), do: false
end
