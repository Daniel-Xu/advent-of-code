defmodule Day8 do
  use Utils
  @row 6
  @col 50

  def part_one(path \\ "data/day8.txt"), do:
    stream_file(path) |> List.foldl(0, fn(row, acc) -> Enum.sum(row) + acc end)
  def part_two(path \\ "data/day8.txt"), do: stream_file(path) |> render()

  def create_board(row, col) do
    List.duplicate(0, col)
    |> List.duplicate(row)
  end

  def render(board) do
    Enum.each(board, fn(row) ->
      Enum.join(row, "  ") |> String.replace("1", "#") |> String.replace("0", " ") |> IO.puts()
    end)
  end

  def stream_file(name) do
    board = create_board(@row, @col)
    normalize_file(name, " ")
    |> Stream.map(&normalize_command/1)
    |> Enum.reduce(board, fn({name, args}, acc) ->
      apply(__MODULE__, name, [acc | args])
    end)
  end

  @doc """
  break list into tow lists and then concat them
  [1,2,3,4] -> [1,2], [3,4] -> [3, 4, 1, 2]
  """
  def rotate_row(board, start, step) do
    List.update_at(board, start, &(rotate(&1, step)))
  end

  def rotate_column(board, start, step) do
    transpose(board)
    |> List.update_at(start, &(rotate(&1, step)))
    |> transpose()
  end

  defp rotate([], _), do: []
  defp rotate(line, step) when is_list(line) do
    line_count = Enum.count(line)
    step = rem(step, line_count)
    {first, second} = Enum.split(line,  line_count - step)

    second ++ first
  end

  def transpose(board) do
    board
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def turn_on_rect(board, wide, tall) do
    0..(tall-1)
    |> Enum.reduce(board, fn(row, board) ->
      line = Enum.at(board, row)
      new_line = Enum.reduce(0..(wide-1), line, &List.replace_at(&2, &1, 1))
      List.replace_at(board, row, new_line)
    end)
  end

  @doc """
  Handle input file
  """
  def normalize_line(data, _pattern), do: data

  defp normalize_command(<<"rect ", t::binary>>) do
    args = String.split(t, "x") |> Enum.map(&String.to_integer/1)
    {:turn_on_rect, args}
  end
  defp normalize_command(<<"rotate ", t::binary>>), do: normalize_rotate(t)

  defp normalize_rotate(<<"row ", t::binary>>) do
    [[start], [step]] = Regex.scan(~r/\d+/, t)
    {:rotate_row, [String.to_integer(start), String.to_integer(step)]}
  end
  defp normalize_rotate(<<"column ", t::binary>>) do
    [[start], [step]] = Regex.scan(~r/\d+/, t)
    {:rotate_column, [String.to_integer(start), String.to_integer(step)]}
  end
end
