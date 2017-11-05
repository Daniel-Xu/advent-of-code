defmodule Day10 do
  use Utils

  def main() do
    state = process("data/day10.txt")
    (for bin <- ["output0", "output1", "output2"], do: get_in(state, [bin, :values]))
    |> List.flatten()
    |> Enum.reduce(&Kernel.*/2)
  end

  def process(name) do
    normalize_file(name)
    |> Stream.map(&normalize_command/1)
    |> Enum.sort_by(&(&1), &>=/2)
    |> Enum.reduce(%{}, fn({name, args}, state) ->
      apply(__MODULE__, name, [state | args])
    end)
  end

  @doc """
  "bot111" => %{high: "1" low: "20"}
  """
  def dispatch(state, value, to) do
    new_state =
      Map.update(state, to, %{low: nil, high: nil, values: [value]}, fn(bot) ->
        %{bot|values: [value|bot.values]}
      end)
    if String.contains?(to, "bot"), do: compare(new_state, to), else: new_state
  end

  def compare(state, to) do
    %{values: v, high: high, low: low} = Map.get(state, to)

    if Enum.count(v) == 2 do
      if [17, 61] -- v == [], do: IO.puts "The Bot is #{to}"
      put_in(state, [to, :values], [])
      |> dispatch(Enum.max(v), high)
      |> dispatch(Enum.min(v), low)
    else
      state
    end
  end

  def transfer(state, from, low_to, high_to) do
    Map.update(state, from, %{high: high_to, low: low_to, values: []}, fn(bot) ->
      %{bot | high: high_to, low: low_to}
    end)
  end

  def normalize_line(data, _pattern), do: data

  def normalize_command(<<"value ", t::binary>>) do
    [[value], [bot_n]] = Regex.scan(~r/\d+/, t)
    {:dispatch, [String.to_integer(value), "bot#{bot_n}"]}
  end
  def normalize_command(<<"bot ", _tail::binary>> = t) do
    args =
      String.split(t, ["gives low to", "and high to"])
      |> Enum.map(&String.replace(&1, " ", ""))

    {:transfer, args}
  end
end
