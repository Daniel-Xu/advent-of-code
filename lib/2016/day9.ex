defmodule Day9 do
  def part_one(), do: load_file("data/day9.txt") |> process()
  def part_two(), do: load_file("data/day9.txt") |> process(true)

  def load_file(path) do
    File.read!(path)
    |> String.trim()
  end

  def process(content, expand? \\ false, acc \\ 0)
  def process(<<>>, _expand?, acc), do: acc
  def process(<<?(, t::binary>> = content, expand?, acc) do
    [pattern, len, num] = Regex.run(~r/\((\d+)x(\d+)\)/, content)
    pattern_len = byte_size(pattern)
    len = String.to_integer(len)
    num = String.to_integer(num)
    skip = len + pattern_len - 1

    case expand? do
      true ->
        head_len = pattern_len - 1
        <<_pattern::binary-size(head_len), child::binary-size(len), new::binary>> = t
        acc = acc + num * process(child, true, 0)
        process(new, true, acc)
      false ->
        <<_h::binary-size(skip), new::binary>> = t
        process(new, false, acc + len * num)
    end
  end
  def process(<<_h::binary-size(1), t::binary>>, expand?, acc), do: process(t, expand?, acc + 1)
end
