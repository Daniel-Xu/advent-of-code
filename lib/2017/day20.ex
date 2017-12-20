defmodule AOC17.Day20 do
  use Utils

  def handle(name \\ "data/2017/day20.txt")  do
    normalize_file(name)
    |> Enum.with_index()
    |> Enum.map(&{Matrix.from_list(elem(&1, 0)), elem(&1, 1)})
  end

  def part_one_two() do
    state = handle()
    process(state, nil, 0)
  end

  def process(_state, min, n) when n > 200, do: min
  def process(state, min, n) do
    {state, {new_i, _}} =
      Enum.map_reduce(state, {nil, 1000000}, fn({m, i}, {min_i, value}) ->
        p = %{m[0] | 0 => m[0][0] + m[1][0] + m[2][0],
              1 => m[0][1] + m[1][1] + m[2][1],
              2 => m[0][2] + m[1][2] + m[2][2]
             }

        v = %{m[1] | 0 => m[1][0] + m[2][0],
              1 => m[1][1] + m[2][1],
              2 => m[1][2] + m[2][2]
             }

        p_v = Map.values(p) |> Enum.reduce(&Kernel.+(abs(&1), abs(&2)))
        acc = if value > p_v, do: {i, p_v}, else: {min_i, value}

        {{%{m | 0 => p, 1 => v}, i}, acc}
      end)

    # part_two
    uniq_state = Enum.uniq_by(state, fn({m, _i}) -> m[0] end)
    repetition = (state -- uniq_state) |> Enum.map(fn({m, _i}) -> m[0] end)
    state = Enum.reject(state, fn({m, _i}) -> m[0] in repetition end)
    new_i = Enum.count(state)

    n = if min == new_i, do: n + 1, else: 0
    process(state, new_i, n)
  end

  def normalize_line(data, _pattern) do
    Regex.scan(~r/(?<=<).*?(?=>)/, data)
    |> Enum.map(fn([str]) ->
      String.split(str, ",") |> Enum.map(&String.to_integer/1)
    end)
  end
end
