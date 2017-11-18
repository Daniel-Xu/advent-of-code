defmodule Day17 do
  @input "udskfozm"

  @doc """
  shotest path

  BFS with queue
  node: %{x: 0, y: 0, code: @code}
  adjacent: %{x: 0, y: 1, code: @code: previous + U}
  don't need to keep a visited MapSet (everytime, the code will be different)

  for longest, we just need to return node {3,3}'s ajacent nodes as []
  """

  def part_one(input \\ @input) do
    start = {0, 0, input}
    :queue.from_list([start])
    |> process(false, start)
  end

  # This is for part two
  def process({[], []}, _stop, current_node), do: current_node
  # This is for part one
  # def process(_queue, true, current_node), do: current_node
  def process(queue, _should_stop, _current_node) do
    {{:value, node}, queue} = :queue.out(queue)

    adjacent_nodes(node)
    |> Enum.reduce(queue, fn(neighbour, queue) ->
      :queue.in(neighbour, queue)
    end)
    |> process(stop?(node), node)
  end

  def adjacent_nodes({3, 3, _code}), do: []
  def adjacent_nodes({x, y, code}) do
    [{x, y + 1, code <> "D"}, {x, y - 1, code <> "U"}, {x + 1, y, code <> "R"}, {x - 1, y, code <> "L"}]
    |> Enum.filter(&valid?/1)
  end

  def valid?({x, y, _code}) when x < 0 or y < 0 or x > 3 or y > 3, do: false
  def valid?({_x, _y, code}) do
    {code, direction} = String.split_at(code, -1)
    open?(code, direction)
  end

  def open?(code, "U"), do: do_check(code, 0)
  def open?(code, "D"), do: do_check(code, 1)
  def open?(code, "L"), do: do_check(code, 2)
  def open?(code, "R"), do: do_check(code, 3)

  def do_check(code, n) do
    <<v>> = get_hash(code) |> String.at(n)
    v in ?b..?f
  end

  def get_hash(code),
    do: :crypto.hash(:md5, code) |> Base.encode16(case: :lower) |> String.slice(0..3)

  def stop?({3, 3, _code}), do: true
  def stop?(_node), do: false
end
