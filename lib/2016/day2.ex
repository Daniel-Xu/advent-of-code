defmodule Day2 do
  use Utils

  @keyboard %{
    "1" => %{"U" => nil, "D" => "4", "L" => nil, "R" => "2"},
    "2" => %{"U" => nil, "D" => "5", "L" => "1", "R" => "3"},
    "3" => %{"U" => nil, "D" => "6", "L" => "2", "R" => nil},
    "4" => %{"U" => "1", "D" => "7", "L" => nil, "R" => "5"},
    "5" => %{"U" => "2", "D" => "8", "L" => "4", "R" => "6"},
    "6" => %{"U" => "3", "D" => "9", "L" => "5", "R" => nil},
    "7" => %{"U" => "4", "D" => nil, "L" => nil, "R" => "8"},
    "8" => %{"U" => "5", "D" => nil, "L" => "7", "R" => "9"},
    "9" => %{"U" => "6", "D" => nil, "L" => "8", "R" => nil}
  }

  @pad %{
    "1" => %{"U" => nil, "D" => "3", "L" => nil, "R" => nil},
    "2" => %{"U" => nil, "D" => "6", "L" => nil, "R" => "3"},
    "3" => %{"U" => "1", "D" => "7", "L" => "2", "R" => "4"},
    "4" => %{"U" => nil, "D" => "8", "L" => "3", "R" => nil},
    "5" => %{"U" => nil, "D" => nil, "L" => nil, "R" => "6"},
    "6" => %{"U" => "2", "D" => "A", "L" => "5", "R" => "7"},
    "7" => %{"U" => "3", "D" => "B", "L" => "6", "R" => "8"},
    "8" => %{"U" => "4", "D" => "C", "L" => "7", "R" => "9"},
    "9" => %{"U" => nil, "D" => nil, "L" => "8", "R" => nil},
    "A" => %{"U" => "6", "D" => nil, "L" => nil, "R" => "B"},
    "B" => %{"U" => "7", "D" => "D", "L" => "A", "R" => "C"},
    "C" => %{"U" => "8", "D" => nil, "L" => "B", "R" => nil},
    "D" => %{"U" => "B", "D" => nil, "L" => nil, "R" => nil}
  }

  def part_one(), do: load_file("data/day2.txt") |> Stream.map(&process("5", &1)) |> Enum.to_list()
  def part_two(), do: load_file("data/day2.txt") |> Stream.map(&process("5", &1, @pad)) |> Enum.to_list()

  def keyboard(), do: @keyboard

  def process(code, commands, keyboard \\ @keyboard) do
    Enum.reduce(commands, code, fn(command, n) ->
      next = keyboard[n][command]
      if next == nil, do: n, else: next
    end)
  end

  def load_file(name) do
    normalize_file(name, "")
  end

  def normalize_line(data, pattern) do
    data
    |> String.split(pattern, trim: true)
  end
end
