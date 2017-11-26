defmodule Day22 do
  use Utils
  @doc """
  requirement
  A: Used(A) > 0
  B: Avai(B) > Used(A)

  approach

  O(N ^ 2)
  state: [{"0,0", used, avail}, {"0,1", used, avail}]
  [h | t] = state
  Enum.reduce(0, requirement)

  part_two
  {x: 38, y: 24}
  - mark used > 91 (empty space) as wall
  - find the shortest path from empty -> Target(G)
  - move empty space ahead G
  - move G
  - repeat
  """

  def part_one(name \\ "data/day22.txt") do
    state = normalize_file(name, " ") |> Enum.to_list()
    process(state, state, 0)
  end

  def process([], _state, acc), do: acc
  def process([{name, {used, _available}} | t], state, acc) do
    acc =
      Enum.reduce(state, 0, fn({node_name, {_node_used, node_available}}, n) ->
        is_pair = name != node_name && used > 0 && node_available > used
        if is_pair, do: n + 1, else: n
      end)
      |> Kernel.+(acc)

    process(t, state, acc)
  end

  def normalize_line(data, pattern) do
    [name, _capacity, used, available, _percent] = String.split(data, pattern, trim: true)
    [_match, x, y] = Regex.run(~r/x(\d+)-y(\d+)/, name)
    used = String.replace(used, "T", "") |> String.to_integer()
    available = String.replace(available, "T", "") |> String.to_integer()
    {"#{x},#{y}", {used, available}}
  end

  def draw(name \\ "data/day22.txt") do
    normalize_file(name, " ")
    |> Stream.map(fn({node, {u, a}}) ->
      symbolize(node, u, a, u + a)
    end)
    |> Enum.chunk_every(24)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
    |> IO.puts()
  end

  def symbolize(_n, u, _a, _s) when u > 91, do: "#"
  def symbolize("0,0", u, _a, _s), do: "0"
  def symbolize("37,0", u, _a, _s), do: "G"
  def symbolize(_n, 0, _a, _s), do: '_'
  def symbolize(_n, _u, _a, _s), do: "."
end
