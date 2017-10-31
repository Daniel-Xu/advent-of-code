defmodule Day7 do
  use Utils

  def part_one(), do: abba("data/day7.txt")
  def part_two(), do: ssl("data/day7.txt")

  def abba(name) do
    normalize_file(name, "")
    |> Stream.filter(&filter/1)
    |> Stream.filter(&validate_abba/1)
    |> Enum.count()
  end

  def ssl(name) do
    normalize_file(name, "")
    |> Stream.filter(&validate_aba/1)
    |> Enum.count()
  end

  def validate_aba(line) do
    bracket_content = Regex.scan(~r/(?<=\[)\w*/, line) |> Enum.map(fn([element]) -> element end)
    Regex.split(~r/\[\w*\]/, line)
    |> Enum.flat_map(&aba_to_bab/1)
    |> Enum.uniq()
    |> Enum.any?(fn(pattern) ->
      Enum.any?(bracket_content, &String.contains?(&1, pattern))
    end)
  end

  def filter(line) do
    valid? =
      Regex.scan(~r/(?<=\[)\w*/, line)
      |> Enum.any?(fn([element]) ->
        validate_abba(element)
      end)

    not valid?
  end

  def validate_abba(line) do
    Regex.scan(~r/(.)(.)\2\1/, line)
    |> Enum.any?(fn([_captured, first, second]) -> first != second end)
  end

  def normalize_line(data, _pattern) do
    data
  end

  # This will not work,
  # Regex.scan(~r/(.)(.)\1/, "abab") only return `aba`, no `bab`
  # we need manually search
  def aba_to_bab(content) do
    aba_to_bab(content, [])
  end

  def aba_to_bab(<<>>, acc), do: acc
  def aba_to_bab(<<a, b, a, t::binary>>, acc) when a != b do
    aba_to_bab(<<b, a, t::binary>>, [<<b, a, b>> | acc ])
  end
  def aba_to_bab(<<_h, t::binary>>, acc), do: aba_to_bab(t, acc)
end
