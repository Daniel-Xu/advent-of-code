defmodule Day24 do
  @doc """
  The shortest path for each pair might visit existing vertex
  """
  def permutation([]), do: [[]]
  def permutation(l) do
    for x <- l, y <- permutation(List.delete(l, x)), do: [x | y]
  end

  def part_one() do
    d = distances()

    (for x <- 1..7, do: "#{x}")
    |> permutation()
    |> Enum.map(&calculate_d(["0" | &1], d))
  end

  def part_two() do
    d = distances()

    (for x <- 1..7, do: "#{x}")
    |> permutation()
    |> Enum.map(&calculate_d(["0" | &1] ++ ["0"], d))
  end

  def calculate_d(l, distances, acc \\ 0)
  def calculate_d([_], _distances, acc), do: acc
  def calculate_d([a, b | t], distances, acc) do
    acc = Map.get(distances, Enum.sort([a, b])) + acc
    calculate_d([b | t], distances, acc)
  end

  @doc """
  all the distances
  """
  def distances() do
    destinations()
    |> combination()
    |> Enum.reduce(%{}, fn({{x1, y1, n1}, {x2, y2, n2}}, acc) ->
      d = search({x1, y1}, {x2, y2})
      Map.put(acc, Enum.sort([n1, n2]), d)
    end)
  end

  @doc """
  from result, we can see the destinations are:
  0 - 7
  x: 36
  y: 178
  """
  def destinations(name \\ "data/day24.txt") do
    maze(name)
    |> Enum.flat_map(fn({{x, y}, v}) ->
      is_destination = not is_boolean(v)
      case is_destination do
        true -> [{x, y, v}]
        _ -> []
      end
    end)
  end

  def maze(name \\ "data/day24.txt") do
    File.stream!(name)
    |> Stream.with_index()
    |> Enum.reduce(%{}, fn({l, i}, acc) ->
      String.trim(l)
      |> parse(i, 0, [])
      |> Enum.reduce(acc, fn({x, y, v}, acc) ->
        Map.put(acc, {x, y}, v)
      end)
    end)
  end

  def combination(list, acc \\ [])
  def combination([], acc), do: acc
  def combination([h | t], acc) do
    l = for x <- t, do: {h, x}
    combination(t, l ++ acc)
  end

  @doc """
  search two destination
  """
  def search(s, e) do
    maze = maze()

    :queue.from_list([s])
    |> process(maze, e,  MapSet.new([]), false, %{s => 0})
    |> Map.get(e)
  end

  @doc """
  BFS
  """
  def process(_queue, _maze, _destination, _visited, true, distance), do: distance
  def process({[], []}, _maze, _destination, _visited, _stop, _distance), do: nil
  def process(queue, maze, destination, visited, stop, distance) do
    {{:value, item}, queue} = :queue.out(queue)
    if MapSet.member?(visited, item) do
      process(queue, maze, destination, visited, stop, distance)
    else
      visited = MapSet.put(visited, item)
      {queue, stop, distance} =
        case item == destination do
          true ->
            {queue, true, distance}
          false ->
            {new_queue, new_distance} =
              adjacent_nodes(item, visited, maze)
              |> in_adjacent(item, queue, distance)
            {new_queue, false, new_distance}
        end
      process(queue, maze, destination, visited, stop, distance)
    end
  end

  def adjacent_nodes({x, y}, visited, maze) do
    [{x, y - 1}, {x, y + 1}, {x + 1, y}, {x - 1, y}]
    |> Enum.filter(fn(e) ->
      !MapSet.member?(visited, e) && valid?(e, maze)
    end)
  end

  def valid?({x, y}, _maze) when x < 0 or y < 0 or x > 36 or y > 178, do: false
  def valid?(n, maze), do: Map.get(maze, n)

  def in_adjacent(adjacents, item, queue, distance) do
    steps = Map.get(distance, item) + 1
    Enum.reduce(adjacents, {queue, distance}, fn(e , {queue, distance}) ->
      {:queue.in(e, queue), Map.put(distance, e, steps)}
    end)
  end

  @doc """
  maze parser
  """
  def parse(<<>>, _x, _y, acc), do: acc
  def parse(<<"#", t::binary>>, x, y, acc), do: parse(t, x, y + 1, [{x, y, false} | acc])
  def parse(<<".", t::binary>>, x, y, acc), do: parse(t, x, y + 1, [{x, y, true} | acc])
  def parse(<<n::binary-size(1), t::binary>>, x, y, acc), do: parse(t, x, y + 1,[{x, y, n} | acc])
end
