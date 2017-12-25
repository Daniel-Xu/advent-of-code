defmodule AOC17.Day25 do

  def process(_, m, _value, _index, 12861455),
    do: Map.values(m) |> Enum.sum()

  def process(:a, m, 0, index, acc),
    do: process(:b, Map.put(m, index, 1), Map.get(m, index + 1, 0), index + 1, acc + 1)
  def process(:a, m, 1, index, acc),
    do: process(:b, Map.put(m, index, 0), Map.get(m, index - 1, 0), index - 1, acc + 1)

  def process(:b, m, 0, index, acc),
    do: process(:c, Map.put(m, index, 1), Map.get(m, index - 1, 0), index - 1, acc + 1)
  def process(:b, m, 1, index, acc),
    do: process(:e, Map.put(m, index, 0), Map.get(m, index + 1, 0), index + 1, acc + 1)

  def process(:c, m, 0, index, acc),
    do: process(:e, Map.put(m, index, 1), Map.get(m, index + 1, 0), index + 1, acc + 1)
  def process(:c, m, 1, index, acc),
    do: process(:d, Map.put(m, index, 0), Map.get(m, index - 1, 0), index - 1, acc + 1)

  def process(:d, m, 0, index, acc),
    do: process(:a, Map.put(m, index, 1), Map.get(m, index - 1, 0), index - 1, acc + 1)
  def process(:d, m, 1, index, acc),
    do: process(:a, Map.put(m, index, 1), Map.get(m, index - 1, 0), index - 1, acc + 1)

  def process(:e, m, 0, index, acc),
    do: process(:a, Map.put(m, index, 0), Map.get(m, index + 1, 0), index + 1, acc + 1)
  def process(:e, m, 1, index, acc),
    do: process(:f, Map.put(m, index, 0), Map.get(m, index + 1, 0), index + 1, acc + 1)

  def process(:f, m, 0, index, acc),
    do: process(:e, Map.put(m, index, 1), Map.get(m, index + 1, 0), index + 1, acc + 1)
  def process(:f, m, 1, index, acc),
    do: process(:a, Map.put(m, index, 1), Map.get(m, index + 1, 0), index + 1, acc + 1)

  def run() do
    process(:a, %{}, 0, 0, 0)
  end
end
