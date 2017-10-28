defmodule Utils do
  defmacro __using__(_opts) do
    quote do
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def normalize_file(file_name, pattern \\ " ") do
        file_name
        |> File.stream!
        |> Stream.map(&String.trim/1)
        |> Stream.map(&normalize_line(&1, pattern))
      end

      def normalize_line(data, pattern) do
        data
        |> String.split(pattern, trim: true)
        |> Enum.map(&String.to_integer/1)
      end

      defoverridable [normalize_line: 2]
    end
  end
end
