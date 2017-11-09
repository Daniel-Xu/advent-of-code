defmodule Day13 do
  require Integer
  alias Day13.Coordinate

  @fav 1364

  def search(%{x: x, y: y}), do: search(x, y)
  def search(x, y) do
    {:ok, coordinate} = Coordinate.new(1, 1)
    :queue.from_list([coordinate])
    |> process(%{x: x, y: y}, MapSet.new([]), false, %{})
    |> calc("#{x},#{y}", 0)
  end

  def calc(nil, _, _acc), do: nil
  def calc(_history, "1,1", acc), do: acc
  def calc(history, key, acc) do
    key =
      Map.get(history, key)
      |> Coordinate.to_key()

    calc(history, key, acc + 1)
  end

  def create_coordinates() do
    for x <- 0..50, y <- 0..50 - x do
      {:ok, item} = Coordinate.new(x, y)
      item
    end
  end

  def number() do
    create_coordinates()
    |> Enum.filter(&open?/1)
    |> Enum.filter(fn(x) ->
      case search(x) do
        nil -> false
        n -> n <= 50
      end
    end)
    |> Enum.count
  end

  @doc """
  BFS
  """
  def process(_queue, _destination, _visited, stop, pre) when stop == true, do: pre
  def process({[], []}, _destination, _visited, _stop, _pre), do: nil
  def process(queue, %{x: x, y: y} = destination, visited, _stop, pre) do
    {{:value, item}, queue} = :queue.out(queue)
    visited = MapSet.put(visited, item)
    {queue, stop, pre} =
      case destination?(item, x, y) do
        true ->
          {queue, true, pre}
        false ->
          {new_queue, new_pre} =
            adjacent_queue(item, visited)
            |> in_adjacent(item, queue, pre)
          {new_queue, false, new_pre}
      end

    process(queue, destination, visited, stop, pre)
  end

  def adjacent_queue(%{x: x, y: y}, visited) do
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

  def in_adjacent(adjacent, item, queue, pre) do
    Enum.reduce(adjacent, {queue, pre}, fn(x, {queue, pre}) ->
      {:queue.in(x, queue), Map.put(pre, Coordinate.to_key(x), item)}
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
