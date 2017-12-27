defmodule AOC17.DayX do
  use Utils

  def handle(name \\ "data/2017/dayX.txt")  do
    normalize_file(name)
    |> Enum.to_list()
    |> IO.inspect
  end

  def normalize_line(data, _pattern), do: data
end
