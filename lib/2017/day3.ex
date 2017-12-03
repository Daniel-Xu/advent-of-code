defmodule AOC17.Day3 do
  use Utils
  require Integer

  @doc """
  naive solution:

  we can get the number of every cycle: n * 2 + 1
  then, we can get the last number of each cycle:
  -> (n * 2 + 1) + (n * 2 + 1 - 2) * 2 + previous sum of cycle elements

  distance 1 -> 3*2 + (3-2) * 2 = 8  -> 9
  distance 2 -> 5*2 + (5-2)*2 = 16  -> 25

  then we use the four middle points to get the distance
             v
     17  16  15  14  13
     18   5   *   *  12
   > 19   6   *   *  11 <
     20   7   8   9  10
     21  22  23---> ...
             ^
  """
  @input 312051
  def part_one(i \\ @input) do
    {n, l} =
      Stream.unfold({1, 1}, fn
      {_n, acc} when acc >= i -> nil
      {n, acc} ->
          acc = (n * 2 + 1) * 2 + (n * 2 - 1) * 2 + acc
          {{n, acc}, {n+1, acc}}
      end)
      |> Enum.to_list()
      |> List.last()

    Enum.map([l - n, l - n * 3, l - n * 5, l - n * 7], fn(n) ->
      abs(n - i)
    end)
    |> Enum.min()
    |> Kernel.+(n)
  end

  @doc """

  Spiral move
  1: right: 1, up: n, left: n
  17  16  15  14  13
  18   5   *   *  12
  19   6   * > *  11
  20   7   8   9  10
  21  22  23---> ...

  2: left: 1, down: n, right: n
  17  16  15  14  13
  18   ^ < 4   3  12
  19   ^   1   2  11
  20   ^   ^   ^  10
  21  22  23---> ...

  each time, it will complete a square
  """

  def spiral_moves() do
    Stream.resource(
      fn -> 1 end,
      fn
        n when Integer.is_odd(n) -> {[right: 1, up: n, left: n], n + 1}
        n when Integer.is_even(n) -> {[left: 1, down: n, right: n], n + 1}
      end,
      fn _ -> :ok end
    )
    |> Stream.flat_map(fn
      {direction, steps} -> Stream.map(1..steps, fn _step -> {direction, 1} end)
    end)
  end

  @doc """
  coordinates without the first one, {0, 0}
         ▲
      ┌──┴───┐
    ──┤(0, 0)├───▶
      └──┬───┘
  """
  def coordinates(moves) do
    Stream.scan(moves, %{x: 0, y: 0}, fn
      {:right, n}, coor -> update_in(coor.x, &(&1 + n))
      {:left, n}, coor -> update_in(coor.x, &(&1 - n))
      {:up, n}, coor -> update_in(coor.y, &(&1 + n))
      {:down, n}, coor -> update_in(coor.y, &(&1 - n))
    end)
  end

  @doc """
  the main purpose of this function is to add the initial %{x: 0, y: 0} to the stream
  """
  def full_coordinates() do
    spiral_moves()
    |> coordinates()
    |> Stream.transform(%{tag: 1, coor: %{x: 0, y: 0}}, fn
      coordinate, coordinate_with_tag ->
        {
          [coordinate_with_tag],
          %{coordinate_with_tag | coor: coordinate, tag: coordinate_with_tag.tag + 1}
        }
    end)
  end

  @doc """
  sum of adjacents' tags
  """
  def sum_values() do
    spiral_moves()
    |> coordinates()
    |> Stream.transform(%{%{x: 0, y: 0} => 1}, fn
      coordinate, state ->
        v = adjacents_sum(state, coordinate)
        {
          [v],
          Map.put(state, coordinate, v)
        }
    end)
  end

  defp adjacents_sum(state, %{x: x, y: y}) do
    (for i <- (x-1)..(x+1), j <- (y-1)..(y+1), {:ok, value} <- [Map.fetch(state, %{x: i, y: j})], do: value)
    |> Enum.sum()
  end


  def part_one_new(i \\ @input) do
    %{coor: coor} =
      full_coordinates()
      |> Stream.drop_while(&(&1.tag != i))
      |> Enum.take(1)
      |> hd()
    abs(coor.x) + abs(coor.y)
  end

  def part_two(i \\ @input) do
    sum_values()
    |> Stream.drop_while(&(&1 <= i))
    |> Enum.take(1)
    |> hd()
  end
end
