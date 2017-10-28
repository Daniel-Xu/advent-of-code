defmodule Day4 do
  use Utils

  def part_one(), do: stream_file("data/day4.txt")
  def part_two(), do: decipher("data/day4.txt")

  defp decipher(name) do
    normalize_file(name, ["-", "[", "]"])
    |> Stream.map(&to_name/1)
    |> Enum.find(fn([name, _id]) ->
       name == "northpole object storage"
    end)
  end

  defp stream_file(name) do
    normalize_file(name, ["-", "[", "]"])
    |> Stream.map(&to_value/1)
    |> Enum.sum()
  end

  def normalize_line(data, pattern) do
    data
    |> String.split(pattern, trim: true)
    |> Enum.split(-2)
  end

  defp to_name({room_name, [sector_id, _checksum]}) do
    # ["qzmt", "abc"]
    name =
      room_name
      |> Enum.map(&transform(&1, sector_id))
      |> Enum.join(" ")
    [name, sector_id]
  end

  def transform(name, sector_id) do
    n =
      String.to_integer(sector_id)
      |> rem(26)

    name
    |> to_charlist()
    |> Enum.map(&forward(&1, n))
    |> to_string()
  end

  defp forward(code, n) do
    if code + n > ?z, do: code + n - 26, else: code + n
  end

  defp to_value({room_name, [sector_id, checksum]}) do
    room_name
    |> Enum.join("")
    |> String.split("", trim: true)
    |> Enum.reduce(%{}, fn(element, acc) ->
      Map.update(acc, element, 1, &(&1 + 1))
    end)
    |> Enum.to_list()
    |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
    |> Enum.sort_by(&elem(&1, 1), &>=/2)
    |> Enum.take(5)
    |> Enum.map_join(&(elem(&1, 0)))
    |> case do
         ^checksum -> String.to_integer(sector_id)
         _ -> 0
       end
  end
end
