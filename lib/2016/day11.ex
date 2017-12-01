defmodule Day11 do
  require Integer

  def example() do
    normalized_state = "12131" |> normalize()
    destination = "44444"
    run(normalized_state, destination)
  end

  def part_one() do
    normalized_state = "11123232323" |> normalize()
    destination = "44444444444"
    run(normalized_state, destination)
  end

  def part_two() do
    normalized_state = "111111123232323" |> normalize()
    destination = "444444444444444"
    run(normalized_state, destination)
  end

  def run(normalized_state, destination) do
    :queue.from_list([normalized_state])
    |> process(destination, MapSet.new([]), false, %{normalized_state => {0, nil}})
    |> Map.get(destination)
    |> elem(0)
    # if you wann see the path, uncomment this, and comment out the previous tow lines
    # |> whole_path(destination)
    # |> Enum.map(&display/1)
  end

  def whole_path(path, destination, acc \\ [])
  def whole_path(_path, nil, [_| acc]), do: acc
  def whole_path(path, destination, acc) do
    parent = Map.get(path, destination) |> elem(1)
    whole_path(path, parent, [parent | acc])
  end

  def display(<<e::binary-1, t::binary>>) do
    Enum.map(1..4, fn(n) ->
      line =
        occurrence(t, "#{n}")
        |> Enum.map(fn(i) ->
          if Integer.is_even(i), do: "G#{div(i, 2) + 1}", else: "M#{div(i, 2) + 1}"
        end)
        |> Enum.join(" ")
      start = if e == "#{n}", do: ". ", else: "F#{n}"
      start <> " " <> line
    end)
    |> Enum.join("\n")
    |> IO.puts()

    IO.puts("############")
  end

  @doc """
  BFS
  """
  def process(_queue, _destination, _visited, true, distance), do: distance
  def process({[], []}, _destination, _visited, _stop, _distance), do: nil
  def process(queue, destination, visited, stop, distance) do
    {{:value, item}, queue} = :queue.out(queue)
    if MapSet.member?(visited, item) do
      process(queue, destination, visited, stop, distance)
    else
      visited = MapSet.put(visited, item)
      {queue, stop, distance} =
        case item == destination do
          true ->
            {queue, true, distance}
          false ->
            {new_queue, new_distance} =
              valid_state(item, visited)
              |> in_adjacent(item, queue, distance)
            {new_queue, false, new_distance}
        end
      process(queue, destination, visited, stop, distance)
    end
  end

  def in_adjacent(adjacents, item, queue, distance) do
    steps = (Map.get(distance, item) |> elem(0)) + 1
    Enum.reduce(adjacents, {queue, distance}, fn(e , {queue, distance}) ->
      {:queue.in(e, queue), Map.put(distance, e, {steps, item})}
    end)
  end

  @doc """
  New moves, valid adjacents nodes
  """
  def valid_state(state, visited) do
    new_state(state)
    |> Enum.filter(fn(<<_e::binary-1, t::binary>> = new_state) ->
      !MapSet.member?(visited, new_state) && valid?(t)
    end)
  end

  @doc """
  3 11 23 23 23 33 valid
  F4
  F3 M M M
  F2 G G G
  F1


  3 22 23 23 33 33 -> invalid

  F1
  F2 G1 M1 G2 G3
  .  M2 M3 G4 M4 G5 M5
  F4
  """
  def valid?(state, valid \\ true, floors \\ {MapSet.new([]), MapSet.new([])})
  def valid?(_state, false, _floors), do: false
  def valid?(<<>>, valid, _floors), do: valid
  def valid?(<<g::binary-1, g::binary-1, t::binary>>, _valid, {g_state, m_state}) do
    g_state = MapSet.put(g_state, g)
    valid?(t, MapSet.disjoint?(g_state, m_state), {g_state, m_state})
  end
  def valid?(<<g::binary-1, m::binary-1, t::binary>>, _valid, {g_state, m_state}) do
    g_state = MapSet.put(g_state, g)
    m_state = MapSet.put(m_state, m)

    valid?(t, MapSet.disjoint?(g_state, m_state), {g_state, m_state})
  end

  @doc """
  on up + two up
  one down + two down
  first floor -> only move up
  4th floor -> only move down
  """
  def new_state(<<e::size(8), _t::binary>> = state) when e == ?1, do: up_state(state)
  def new_state(<<e::size(8), _t::binary>> = state) when e == ?4, do: down_state(state)
  def new_state(state), do: up_state(state) ++ down_state(state)

  def up_state(state), do: up_one(state) ++ up_two(state)
  def down_state(state), do: one_down(state) ++ two_down(state)

  @doc """
  2 11 22 23 23 23
  v
  3 11 32 23 23 23
  3 11 23 23 23 23
  3 11 22 33 23 23
  3 11 22 23 33 23
  3 11 22 23 23 33
  """
  def up_one(<<e::binary-1, t::binary>>) do
    occurrence(t, e) |> handle_one(t, e, 1)
  end

  @doc """
  2 11 22 23 23 23 -> 10
       ^^ ^  ^  ^
  """
  def up_two(<<e::binary-1, t::binary>>) do
    occurrence(t, e)
    |> combination()
    |> handle_two(t, e, 1)
  end

  @doc """
  one down
  two down [pair GG MM]
  """
  def one_down(<<e::binary-1, t::binary>>) do
    occurrence(t, e) |> handle_one(t, e, -1)
  end

  def two_down(<<e::binary-1, t::binary>>) do
    occurrence(t, e)
    |> combination()
    |> handle_two(t, e, -1)
  end

  def handle_one(combo, t, e, diff) do
    Enum.map(combo, fn(i) ->
      u =
        (for << x::size(8) <- t >>, do: x)
        |> List.update_at(i, &(&1 + diff))
        |> List.to_string
      <<d>> = e
      (<<d + diff>> <> u) |> normalize()
    end)
    |> Enum.uniq()
  end

  def handle_two(combo, t, e, diff) do
    Enum.map(combo, fn([i, j]) ->
      u =
        (for << x::size(8) <- t >>, do: x)
        |> List.update_at(i, &(&1 + diff))
        |> List.update_at(j, &(&1 + diff))
        |> List.to_string
      <<d>> = e
      (<<d + diff>> <> u) |> normalize()
    end)
    |> Enum.uniq()
  end

  @doc """
  Get all the valid two elements combination
  """
  def combination(l, acc \\ [])
  def combination([_], acc), do: acc |> Enum.sort()
  def combination([h | t], acc) do
    combo = (for x <- t, valid_pair?(h, x), do: [h, x])

    combination(t, combo ++ acc)
  end

  @doc """
  GG, MM, pair(self)
  """
  def valid_pair?(a, b) when b-a == 1 and  rem(a, 2) == 0, do: true
  def valid_pair?(a, b) when rem(a, 2) == 0 and  rem(b, 2) == 0, do: true
  def valid_pair?(a, b) when rem(a, 2) != 0 and  rem(b, 2) != 0, do: true
  def valid_pair?(_a, _b), do: false

  @doc """
  G will be even
  M will be odd
  """
  def occurrence(s, c) do
    String.split(s, "", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn({n, _i}) -> n == c end)
    |> Enum.map(&elem(&1, 1))
  end

  @doc """
  sort the pairs
  i.e.
  1221 -> 1221
  2112 -> 1221
  """
  def normalize(<<a::binary-1, t::binary>>) do
    floors =
      (for <<x::binary-2 <- t>>, do: x)
      |> Enum.sort()
      |> Enum.join("")
    a <> floors
  end
end
