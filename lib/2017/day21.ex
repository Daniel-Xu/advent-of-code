defmodule AOC17.Day21 do
  use Utils

  def load(name \\ "data/2017/day21.txt")  do
    normalize_file(name, " => ")
    |> Enum.reduce(%{}, fn([k, v], m) ->
      permutation(k) |> Enum.reduce(m, fn(x, m) -> Map.put(m, x, v) end)
    end)
  end

  def run() do
    input = ".#./..#/###"
    book = load()

    process(input, matrix_size(input), book, 0)
  end

  # 8.658 total for part_two
  def process(str, _size, _book, 18), do: str |> cal()
  def process(str, size, book, acc) when size > 2 and rem(size, 2) == 0 do
    str = expand(str, book, 2)
    process(str, matrix_size(str), book, acc + 1)
  end
  def process(str, size, book, acc) when size > 3 and rem(size, 3) == 0 do
    str = expand(str, book, 3)
    process(str, matrix_size(str), book, acc + 1)
  end
  def process(str, _size, book, acc) do
    str = Map.get(book, str)
    process(str, matrix_size(str), book, acc + 1)
  end

  def expand(str, book, n) do
    chunk(str, n)
    |> Enum.map(&Map.get(book, &1))
    |> combine(div(matrix_size(str), n))
  end

  @doc """
  iex> AOC17.Day21.cal("#../#..#")
  3
  """
  def cal(str), do: String.replace(str, ~r/[^#]/, "") |> byte_size()

  @doc """
  iex(46)> m = ["123456", "123456", "123456", "123456", "123456", "123456"] |> Enum.join("/")
  iex(47)> AOC17.Day21.chunk(m, 2)
  ["12/12", "34/34", "56/56", "12/12", "34/34", "56/56", "12/12", "34/34",
  "56/56"]
  """
  def chunk(str, n) do
    String.split(str, "/")
    |> Enum.chunk_every(n)
    |> Enum.flat_map(fn(x) ->
      Enum.map(x, fn(str) ->
        for <<x::binary-size(n) <- str>>, do: x
      end) |> transpose() |> Enum.map(&Enum.join(&1, "/"))
    end)
  end

  @doc """
  iex(47)> m =  ["123/456/789", "abc/def/ghi", "123/456/789", "111/222/333"]
  iex(46)> AOC17.Day21.combine(m, 2)
  "123abc/456def/789ghi/123111/456222/789333"
  """
  def combine(l, n) do
    Enum.chunk_every(l, n)
    |> Enum.flat_map(fn(x) ->
      Enum.map(x, &String.split(&1, "/"))
      |> transpose()
      |> Enum.map(&Enum.join(&1, ""))
    end)
    |>Enum.join("/")
  end

  def matrix_size(str), do: Regex.run(~r/.*?(?=\/)/, str) |> hd() |> byte_size()

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
