defmodule Day14 do
  @salt "ahsbgdzn"
  @look_a_head 1000

  @doc """
  5_seq: %{"h" => [1, 2, 3]}
  # my initial stream solution is too slow for part two, optimized with inspiration from
  reddit solution
  """
  def part_one(salt \\ @salt, n \\ 0) do
    run(salt, n, fn(input) -> :crypto.hash(:md5, input) |> Base.encode16(case: :lower) end)
  end

  def part_two(salt \\ @salt, n \\ 63) do
    run(salt, n, &stretched_hash/1)
  end

  def stretched_hash(input) do
    Enum.reduce(1..2017, input, fn(_n, input) ->
      :crypto.hash(:md5, input) |> Base.encode16(case: :lower)
    end)
  end

  def populate_hash(salt, fun) do
    Enum.reduce(0..@look_a_head - 1, {:queue.new(), %{}}, fn(n, {hashes, seq5}) ->
      hash = fun.("#{salt}#{n}")
      {:queue.in(hash, hashes), update_seq5(seq5, n, hash)}
    end)
  end

  def update_seq5(seq5, n, hash) do
    case Regex.run(~r/(\w)\1{4}/, hash) do
      [_, captured] -> Map.update(seq5, captured, [n], fn(l) -> [n | l] end)
      nil -> seq5
    end
  end

  def run(salt \\ @salt, index \\ 0, fun) do
    {hashes, seq5} = populate_hash(salt, fun)

    solve(index, hashes, seq5, @look_a_head, salt, fun, [])
  end

  def solve(index, _hashes, _seq5, _n, _salt, _fun, indexes) when length(indexes) == index + 1, do: List.first(indexes)
  def solve(index, hashes, seq5, n, salt, fun, indexes) do
    hash = fun.("#{salt}#{n}")
    {{:value, value}, hashes} = :queue.in(hash, hashes) |> :queue.out()
    seq5 = update_seq5(seq5, n, hash)
    indexes = check_seq3_then_update_indexes(value, n - @look_a_head, seq5, indexes)
    solve(index, hashes, seq5, n + 1, salt, fun, indexes)
  end

  def check_seq3_then_update_indexes(hash, n, seq5, indexes) do
    with pattern = check_seq3(hash),
         l when not is_nil(l) <- Map.get(seq5, pattern),
         true <- Enum.any?(l, fn(i) -> i > n end) do
      [n | indexes]
    else
      _ -> indexes
    end
  end

  def check_seq3(hash) do
    case Regex.run(~r/(\w)\1{2}/, hash) do
      [_, captured] -> captured
      nil -> nil
    end
  end

end
