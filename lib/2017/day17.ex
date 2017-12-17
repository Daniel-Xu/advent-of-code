defmodule AOC17.Day17 do
  @input 314

  def part_one() do
    {l, i} = process([0], 0, 1)
    Enum.at(l, i + 1)
  end

  def part_two(), do: process_index(0, 0, 1)

  def process(l, current, 2018), do: {l, current}
  def process(l, current, i) do
    next_i = rem(@input + current, i) + 1
    process(List.insert_at(l, next_i, i), next_i, i + 1)
  end

  def process_index(_current, v, 50000001), do: v
  def process_index(current, v, i) do
    next_i = rem(@input + current, i) + 1
    v = if next_i == 1, do: i, else: v
    process_index(next_i, v, i + 1)
  end
end
