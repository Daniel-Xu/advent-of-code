defmodule AOC17.Day21 do
  use Utils

  def load(name \\ "data/2017/day21.txt")  do
    normalize_file(name, " => ")
    |> Enum.reduce(%{}, fn([k, v], m) ->
      permutation(k) |> Enum.reduce(m, fn(p, m) -> Map.put(m, p, v) end)
    end)
  end

  def run(n) do
    input = ".#./..#/###"
    book = load()

    process(input, book, n, 0)
  end

  def process(str, book, 18, res), do: res
  def process(str, book, n, acc) do
    if matrix_size(str) == 4 do
      children = divide_4(str)
      |> Enum.reduce(0, fn(c_str, acc) ->
        acc + process(c_str, book, n, 0)
      end)
    else
      pattern = find_pattern(str, book)
      acc = Regex.replace(~r/\.|\//, pattern, "") |> byte_size()

      process(pattern, book, n + 1, acc)
    end
  end

  def matrix_size(str), do: Regex.run(~r/.*?(?=\/)/, str) |> hd() |> byte_size()

  def divide_4(str) do
    Regex.replace(~r/(.{2})(.{2})\/(.{2})(.{2})\/(.{2})(.{2})\/(.{2})(.{2})/, str, "\\1\\3/\\2\\4/\\5\\7/\\6\\8")
    |> String.split("/", trim: true)
    |> Enum.map(fn(l) ->
      String.split(l, "", trim: true)
      |> Enum.chunk_every(2)
    end)
    |> Enum.map(&to_str/1)
  end

  def flip_x(matrix), do: Enum.reverse(matrix)
  def flip_y(matrix), do: for x <- matrix, do: Enum.reverse(x)

  def rotate(matrix), do: transpose(matrix) |> flip_y()
  def rotates(matrix), do: Stream.iterate(matrix, &rotate/1) |> Enum.take(4)

  def transpose(matrix) do
    List.zip(matrix)
    |> Enum.map(&Tuple.to_list/1)
  end

  def to_str(matrix), do: Enum.map(matrix, &Enum.join(&1, "")) |> Enum.join("/")
  def to_matrix(str) do
    String.split(str, "/")
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def find_pattern(str, book), do: Map.get(book, str)

  def permutation(str) do
    matrix = to_matrix(str)
    rotates(matrix)
    |> Enum.flat_map(fn(m) ->
      [m, flip_x(m), flip_y(m)]
    end)
    |> Enum.uniq()
    |> Enum.map(&to_str/1)
  end

  def normalize_line(data, pattern), do: String.split(data, pattern)
end
