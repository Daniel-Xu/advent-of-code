defmodule AOC17.Day7 do
  use Utils

  def part_one(name \\ "data/2017/day7.txt")  do
    s = normalize_file(name, "-> ")
    total = Enum.map(s, &elem(&1, 0))
    children = Enum.reduce(s, [], fn({_, _, c}, acc) ->
      c ++ acc
    end)
    (total -- children) |> hd()
  end

  @doc """
  DFS find the unbalanced branch
  """
  def part_two(name \\ "data/2017/day7.txt")  do
    s = normalize_file(name, "-> ")
    try do
      weights(s, part_one())
    catch
      {l, n} ->
        z = Enum.zip(l, n)
        {_i_target, n_target} =
          (for {i_a, _n_a} = a <- z, not i_a in (List.delete(z, a) |> Enum.map(&elem(&1, 0))), do: a)
          |> List.first()

        diff = Enum.uniq(l) |> Enum.reduce(&Kernel.-/2) |> abs()
        {_, weight, _} = Enum.find(s, fn(n) -> elem(n, 0) == n_target end)
        weight - diff
    end
  end

  defp weights(s, h) do
    {_, weight, children} = Enum.find(s, fn(n) -> elem(n, 0) == h end)
    if children == [] do
      weight
    else
      l_w = for c_name <- children, do: weights(s, c_name)
      c_sum = Enum.sum(l_w)
      if Enum.dedup(l_w) |> Enum.count() != 1 , do: throw({l_w, children})

      c_sum + weight
    end
  end

  def normalize_line(data, pattern) do
    case String.split(data, pattern) do
      [parent, children] ->
        [_, name, weight] = Regex.run(~r/(\w+) \((\d+)\)/, parent)
        {name, String.to_integer(weight), String.split(children, ", ", trim: true)}
      [node] ->
          [_, name, weight] = Regex.run(~r/(\w+) \((\d+)\)/, node)
          {name, String.to_integer(weight), []}
    end
  end
end
