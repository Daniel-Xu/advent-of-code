defmodule AOC17.Day6 do

  @input "4	10	4	1	8	4	9	14	5	1	14	15	0	15	3	5"
  def part_one()  do
    String.split(@input, "\t")
    |> Enum.map(&String.to_integer/1)
    |> process(MapSet.new(), false, 0, &MapSet.member?/2)
  end

  def part_two() do
    {t, _} = part_one()
    {_, acc} =
      process(t, MapSet.new(), false, 0, fn(collection, _l) ->
        MapSet.member?(collection, t)
      end)

    acc - 1
  end

  def process(l, _collection, true, acc, _func), do: {l, acc}
  def process(l, collection, _should_stop, acc, func) do
    max = Enum.max(l)
    i = Enum.find_index(l, fn(x) -> x == max end)
    l = List.replace_at(l, i, 0) |> distribute(i + 1, length(l), max)
    should_stop = func.(collection, l)
    collection = MapSet.put(collection, l)

    process(l, collection, should_stop, acc + 1, func)
  end

  def distribute(l, _i, _len, max) when max == 0, do: l
  def distribute(l, i, len, max) do
    i = rem(i, len)
    distribute(List.update_at(l, i, &(&1 + 1)), i + 1, len, max - 1)
  end
end
