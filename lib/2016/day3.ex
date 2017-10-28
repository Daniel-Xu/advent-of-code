defmodule Day3 do
  use Utils

  def part_one(), do: stream_file("data/day3.txt")
  def part_two(), do: stream_file_with_chunk("data/day3.txt", 3)

  def stream_file_with_chunk(name, chunk_num) do
    # data after chunk
    # [[[566, 477, 376], [575, 488, 365], [50, 18, 156]],
    #  [[558, 673, 498], [133, 112, 510], [670, 613, 25]]]
    normalize_file(name)
    |> Stream.chunk_every(chunk_num)
    |> Stream.flat_map(&Enum.zip/1)
    |> Stream.filter(&validate/1)
    |> Enum.count()
  end

  def stream_file(name) do
    normalize_file(name)
    |> Stream.filter(&validate/1)
    |> Enum.count()
  end

  defp validate([a, b, c]), do: (a + b > c) && (a + c > b) && (b + c > a)
  defp validate({a, b, c}), do: validate([a, b, c])
end
