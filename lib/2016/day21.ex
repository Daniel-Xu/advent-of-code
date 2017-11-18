defmodule Day21 do
  use Utils

  @password "abcdefgh"

  @doc """
  Similar with Day12

  - parse instruction
  - generate password
  """
  def part_one(name \\ "data/day21.txt", input \\ @password) do
    cmds = handle(name)
    process(input, cmds)
  end

  # This combinations are fairly small so we can get the result
  # relatively quickly
  def part_two(name \\ "data/day21.txt", input \\ "fbgdceah") do
    cmds = handle(name)
    (for x <- ?a..?h, do: <<x :: utf8>>)
    |> combination()
    |> Enum.reduce_while(0, fn(l, acc) ->
      key = Enum.join(l, "") |> process(cmds)
      if key == input, do: {:halt, l}, else: {:cont, acc}
    end)
  end

  def handle(name) do
    normalize_file(name)
    |> Stream.map(&normalize_command/1)
    |> Enum.to_list()
  end

  def process(password, []), do: password
  def process(password, [{:swap_l, x, y} | t]) do
    {i, _i_l} = :binary.match(password, x)
    {j, _j_l} = :binary.match(password, y)
    do_swap(i, j, x, y, password)
    |> process(t)
  end
  def process(password, [{:swap_p, i, j} | t]) do
    x = String.at(password, i)
    y = String.at(password, j)
    do_swap(i, j, x, y, password)
    |> process(t)
  end
  def process(password, [{:rotate_p, x} | t]) do
    {i, _i_l} = :binary.match(password, x)
    steps = if i + 1 > 4, do: i + 2, else: i + 1

    do_rotate("right", steps, password)
    |> process(t)
  end
  def process(password, [{:rotate_d, direction, steps} | t]) do
    do_rotate(direction, steps, password) |> process(t)
  end
  def process(password, [{:reverse, start, last} | t]) do
    do_reverse(start, last, password) |> process(t)
  end
  def process(password, [{:move, from, to} | t]) do
    do_move(from, to, password) |> process(t)
  end

  defp do_swap(i, j, x, y, password) do
    String.split(password, "", trim: true)
    |> List.replace_at(i, y)
    |> List.replace_at(j, x)
    |> Enum.join("")
  end

  defp do_rotate("right", n, password) do
    len = String.length(password)
    steps = rem(n, String.length(password))
    {head, tail} = String.split_at(password, len - steps)
    tail <> head
  end
  defp do_rotate("left", n, password) do
    steps = rem(n, String.length(password))
    {head, tail} = String.split_at(password, steps)
    tail <> head
  end

  defp do_reverse(i, j, password) do
    len = String.length(password)
    head = if i > 0, do: String.slice(password, 0..i-1), else: ""
    tail = String.slice(password, j+1..len)
    midddle = String.slice(password, i..j) |> String.reverse()
    head <> midddle <> tail
  end

  defp do_move(i, j, password) do
    {head, <<x::binary-size(1), tail::binary>>} = String.split_at(password, i)
    {head, tail} = String.split_at(head <> tail, j)
    head <> x <> tail
  end

  @doc """

  a b c d
  x <- a, [a |combination(bcd)]
  x <- b, [b | combination(acd)]
  ...
  """
  def combination([]), do: [[]]
  def combination(list) do
    for x <- list, y <- combination(List.delete(list, x)), do: [x | y]
  end

  @doc """
  parser
  """
  def normalize_line(data, _pattern), do: data

  defp normalize_command(<<"swap letter ", t::binary>>) do
    [x, y] = String.split(t, " with letter ")
    {:swap_l, x, y}
  end
  defp normalize_command(<<"swap position ", t::binary>>) do
    [x, y] = String.split(t, " with position ")
    {:swap_p, String.to_integer(x), String.to_integer(y)}
  end
  defp normalize_command(<<"rotate based on position of letter ", t::binary>>),
    do: {:rotate_p, t}
  defp normalize_command(<<"rotate ", t::binary>>) do
    [direction, step, _unit] = String.split(t, " ", trim: true)
    {:rotate_d, direction, String.to_integer(step)}
  end
  defp normalize_command(<<"reverse positions ", t::binary>>) do
    [start, _word, last] = String.split(t, " ", trim: true)
    {:reverse, String.to_integer(start), String.to_integer(last)}
  end
  defp normalize_command(<<"move position ", t::binary>>) do
    [from, _to, _position, to] = String.split(t, " ", trim: true)
    {:move, String.to_integer(from), String.to_integer(to)}
  end
end
