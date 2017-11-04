defmodule Star1 do
  def calculate_path(list) do
    calculate_path(list, 0)
  end

  def calculate_path('(' ++ tail, number) do
    calculate_path(tail, number + 1)
  end

  def calculate_path(')' ++ tail, number) do
    calculate_path(tail, number - 1)
  end

  def calculate_path([], number), do: number

end
