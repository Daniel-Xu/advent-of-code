defmodule Day19 do
  require Integer

  @elves 3014387
  def part_one() do
    process(1..@elves, @elves)
  end

  def part_two() do run(@elves) end

  def process(elves, len) when len == 1, do: elves |> List.first
  def process(elves, len) when rem(len, 2) == 0, do: handle(elves) |> process(div(len, 2))
  def process(elves, _len) do
    [_h | t] = handle(elves)
    process(t, Enum.count(t))
  end

  def handle(elves) do
    Enum.with_index(elves)
    |> Enum.filter(fn({_n, index}) ->
      Integer.is_even(index)
    end)
    |> Enum.map(&elem(&1, 0))
  end

  @doc """
  part two (n^2 solution for experiments)

  def run([n | [_p]], _len), do: n
  def run(l, len) do
    n = len |> div(2)
    {value, [h | t]} = List.pop_at(l, n)
    IO.inspect value
    run(t ++ [h], len - 1)
  end
  """
  def run(n) do
    half = div(n, 2)
    left = Enum.to_list(1..half) |> :queue.from_list()
    right = Enum.to_list((half + 1)..n) |> :queue.from_list()
    run(left, right, rem(n, 2))
  end

  def run({[], []}, {[n], []}, _difference), do: n

  def run(left, right, 2) do
    {{:value, in_left}, right} = :queue.out(right)
    left = :queue.in(in_left, left)

    run(left, right, 0)
  end
  def run(left, right, difference) do
    right = :queue.drop(right)

    {{:value, in_right}, left} = :queue.out(left)
    right = :queue.in(in_right, right)

    run(left, right, difference + 1)
  end
end
