defmodule Day1 do
  defstruct(
    x: 0,
    y: 0,
    face: "Y",
    polarity: "+"
  )

  def part_one(path \\ "data/day1.txt") do
    load_file(path)
    |> Enum.reduce(%Day1{}, &process(&2, &1))
  end

  def part_two(path \\ "data/day1.txt") do
    load_file(path)
    |> Enum.reduce_while({MapSet.new([[0, 0]]), %Day1{}}, fn(instruction, {footsteps, state}) ->
      current = process(state, instruction)
      current_path = track(state, current)
      if MapSet.disjoint?(footsteps, current_path) do
        {:cont, {MapSet.union(footsteps, current_path), current}}
      else
        {:halt, MapSet.intersection(footsteps, current_path)}
      end
    end)
  end

  def track(%{x: start_x, y: start_y}, %{x: start_x, y: end_y}) do
    Enum.map(start_y..end_y, fn(y) -> [start_x, y] end) -- [[start_x, start_y]]
    |> MapSet.new()
  end
  def track(%{x: start_x, y: start_y}, %{x: end_x, y: start_y}) do
    Enum.map(start_x..end_x, fn(x) -> [x, start_y] end) -- [[start_x, start_y]]
    |> MapSet.new()
  end

  def process(%{face: "Y", polarity: "+"} = current, <<"R", step::binary>>), do:
    %{current | x: current.x + String.to_integer(step), face: "X"}
  def process(%{face: "Y", polarity: "-"} = current, <<"R", step::binary>>), do:
    %{current | x: current.x - String.to_integer(step), face: "X", polarity: "-"}
  def process(%{face: "Y", polarity: "+"} = current, <<"L", step::binary>>), do:
    %{current | x: current.x - String.to_integer(step), face: "X", polarity: "-"}
  def process(%{face: "Y", polarity: "-"} = current, <<"L", step::binary>>), do:
    %{current | x: current.x + String.to_integer(step), face: "X", polarity: "+"}
  def process(%{face: "X", polarity: "+"} = current, <<"R", step::binary>>), do:
    %{current | y: current.y - String.to_integer(step), face: "Y", polarity: "-"}
  def process(%{face: "X", polarity: "-"} = current, <<"R", step::binary>>), do:
    %{current | y: current.y + String.to_integer(step), face: "Y", polarity: "+"}
  def process(%{face: "X", polarity: "+"} = current, <<"L", step::binary>>), do:
    %{current | y: current.y + String.to_integer(step), face: "Y", polarity: "+"}
  def process(%{face: "X", polarity: "-"} = current, <<"L", step::binary>>), do:
    %{current | y: current.y - String.to_integer(step), face: "Y", polarity: "-"}

  def load_file(path) do
    File.read!(path)
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&String.trim/1)
  end
end
