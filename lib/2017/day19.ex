defmodule Matrix do
  def from_list(list) when is_list(list) do
    do_from_list(list)
  end

  defp do_from_list(list, map \\ %{}, index \\ 0)
  defp do_from_list([], map, _index), do: map
  defp do_from_list([h|t], map, index) do
    map = Map.put(map, index, do_from_list(h))
    do_from_list(t, map, index + 1)
  end
  defp do_from_list(other, _, _), do: other
end

defmodule AOC17.Day19 do
  @matrix File.read!("data/2017/day19.txt")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ""))
    |> Matrix.from_list()

  def handle() do
    col = @matrix[0] |> Enum.find(fn {_i, v} -> v == "|" end) |> elem(0)
    process(@matrix, "|", 0, col, 1, 0, {0, []})
  end

  def process(_matrix, " ", _row, _col, _dr, _dc, {step, acc}),
    do: {step, acc |> Enum.reverse() |> Enum.join("")}
  def process(matrix, symb, row, col, dr, dc, {step, acc}) when not symb in ["-", "|", "+"],
    do: process(matrix, get_v(matrix, row + dr, col + dc), row + dr, col + dc, dr, dc, {step + 1, [symb | acc]})
  def process(matrix, symb, row, col, dr, _dc, {step, acc}) when symb == "+" do
    {dr, dc} =
      if dr == 0 do
        if get_v(matrix, row - 1, col) != " ", do: {-1, 0}, else: {1, 0}
      else
        if get_v(matrix, row, col - 1) != " ", do: {0, -1}, else: {0, 1}
      end

    process(matrix, get_v(matrix, row + dr, col + dc), row + dr, col + dc, dr, dc, {step + 1, acc})
  end
  def process(matrix, _symb, row, col, dr, dc, {step, acc}),
    do: process(matrix, get_v(matrix, row + dr, col + dc), row + dr, col + dc, dr, dc, {step + 1, acc})

  defp get_v(matrix, r, c), do: matrix[r][c] || " "
end
