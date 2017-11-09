defmodule Day13 do
  require Integer
  alias Day13.Coordinate

  @fav 1364

  def search(x, y, fun) do
    {:ok, coordinate} = Coordinate.new(1, 1)
    :queue.from_list([coordinate])
    |> process(%{x: x, y: y}, MapSet.new([]), false, %{"1,1" => 0}, fun)
  end

  def part_one() do
    search(31, 39, fn(item, x, y, _) -> destination?(item, x, y) end)
    |> elem(0)
    |> Map.get("31,39")
  end

  def part_two() do
    search(50, 50, fn(item, _, _, distance) ->
      Map.get(distance, Coordinate.to_key(item)) > 50
    end)
    |> elem(1)
    |> Enum.count
    |> Kernel.-(1)
  end

  @doc """
  BFS
  """
  def process(_queue, _destination, visited, stop, distance, _fun) when stop == true, do: {distance, visited}
  def process({[], []}, _destination, _visited, _stop, _distance, _fun), do: nil
  def process(queue, %{x: x, y: y} = destination, visited, _stop, distance, fun) do
    {{:value, item}, queue} = :queue.out(queue)
    visited = MapSet.put(visited, item)
    {queue, stop, distance} =
      case fun.(item, x, y, distance) do
        true ->
          {queue, true, distance}
        false ->
          {new_queue, new_distance} =
            adjacent_nodes(item, visited)
            |> in_adjacent(item, queue, distance)
          {new_queue, false, new_distance}
      end

    process(queue, destination, visited, stop, distance, fun)
  end

  def adjacent_nodes(%{x: x, y: y}, visited) do
    [Coordinate.new(x, y - 1), Coordinate.new(x, y + 1), Coordinate.new(x + 1, y), Coordinate.new(x - 1, y)]
    |> Enum.filter(fn(element) ->
      case element do
        {:ok, item} ->
          !MapSet.member?(visited, item) && open?(item)
        _ -> false
      end
    end)
    |> Enum.map(&elem(&1, 1))
  end

  def in_adjacent(adjacent, item, queue, distance) do
    steps = Map.get(distance, Coordinate.to_key(item)) + 1
    Enum.reduce(adjacent, {queue, distance}, fn(x, {queue, distance}) ->
      {:queue.in(x, queue), Map.put(distance, Coordinate.to_key(x), steps)}
    end)
  end

  def destination?(%{x: x, y: y}, x, y), do: true
  def destination?(_coordinate, _x, _y), do: false

  def open?(%{x: x, y: y}, r \\ @fav) do
    x * x + 3 * x + 2 * x * y + y + y * y + r
    |> Integer.to_string(2)
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
    |> Integer.is_even()
  end
end

defmodule Day13.Coordinate do
  alias __MODULE__

  @enforce_keys [:x, :y]
  defstruct(x: nil, y: nil)

  def new(x, y) when x >= 0 and y >= 0 do
    {:ok, %Coordinate{x: x, y: y}}
  end
  def new(_, _), do: {:error, :invalid_coordinate}

  def to_key(%{x: x, y: y}), do: "#{x},#{y}"
end
