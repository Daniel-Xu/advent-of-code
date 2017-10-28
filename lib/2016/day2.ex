defmodule Star2 do
  def normalize_surface(input) do
    Enum.map(input |> String.split("x"), fn(str) -> String.to_integer(str) end)
  end

  def paper([a, b, c]) do
    surface = [a * b, a * c, b * c]
    leastSurface = Enum.min(surface)

    leastSurface + 2 * Enum.reduce(surface, &(&1 + &2))
  end

  def stream_file(name, action) do
    name
    |> File.stream!
    |> IO.inspect
    |> Stream.map(&String.strip/1)
    |> Stream.map(&normalize_surface/1)
    |> Stream.map(action)
    |> Enum.reduce(&(&1 + &2))
  end

  def ribben(input) do
    max = Enum.max(input)
    first =
      input
      |> List.delete(max)
      |> Enum.reduce(&(&1 + &2))

    second =
      input
      |> Enum.reduce(&(&1 * &2))

    2 * first + second
  end

  def stream_file_paper(name) do
    name
    |> stream_file(&paper/1)
  end
  def stream_file_ribben(name) do
    name
    |> stream_file(&ribben/1)
  end

end
