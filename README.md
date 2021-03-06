# AdventOfCode

## 2016

Skill required to solve AOC 2016:

1. BFS is the king (or you can use A *)
2. Binary pattern matching
3. recursive thinking
4. bit operation
5. File operation (Stream)
6. Regex
7. Some erlang data structures (mostly `:queue`)

## 2017

Key point for each problem

1. For wrap around, you will want to use `rem(i, len)`

2. `Enum.max`, `Enum.min` or `Enum.min_max`

3. Learn the spiral move, this is so important.

```
  Odd: right: 1, up: n, left: n
  17  16  15  14  13
  18   5   *   *  12
  19   6   * > *  11
  20   7   8   9  10
  21  22  23---> ...

  Even: left: 1, down: n, right: n
  17  16  15  14  13
  18   ^ < 4   3  12
  19   ^   1   2  11
  20   ^   ^   ^  10
  21  22  23---> ...
```

4. `(String.codepoints or String.split) |> Enum.sort()`

5. Use `%{}` not `[]` for the `O(1)` happiness

6. `List.update_at`, `List.replace_at` and `MapSet.member?`

7. DFS

8. `String.split(s, " ")`

9. `Regex.scan`

10. List rotate left/right (`Enum.split`)
```elixir
  defp rotate_left(l, n) do
    len = Enum.count(l)
    {h, t} = Enum.split(l, rem(n, len))
    t ++ h
  end

  defp rotate_right(l, n) do
    len = Enum.count(l)
    {h, t} = Enum.split(l, rem(len - n, len))
    t ++ h
  end
```

11. Hex grid: `{x, y} => {x (+/-) 0.5 or 1, y (+/-) 0.5 or 1}`

12. DFS

13. Each cycle will have `(range - 1) * 2` number of elements

14. DFS

15. `mask = (1 <<< len) - 1` to generate `len` number of 1 mask

16. 1 billion times is impossible (find cycyle)

17. Similar with Day1, wrap around: `rem(i, len)`

18. Run two `Map` together: `process([p0, p0_i], [p1, p1_i])`

19. Convert List to Map:
```elixir
[[1, 2], [3, 4]]

# to

%{
  0 => %{0 => 1, 1 => 2}
  1 => %{0 => 3, 1 => 4}
}
```

20. `%{ m | 0 => "new value" }` and `Enum.uniq_by`

21. Matrix Rotate, Flip, Transpose
```elixir
def transpose(matrix) do
  List.zip(matrix) |> Enum.map(&Tuple.to_list/1)
end

def flip_x(matrix), do: Enum.reverse(matrix)

def flip_y(matrix), do: for x <- matrix, do: Enum.reverse(x)

def rotate(matrix), do: transpose(matrix) |> flip_y()
```

22. Using `{dx, dy}` to control direction

23. How to check if N is prime number
```elixir
defp prime_n?(x) do
  Enum.reduce_while(2..div(x, 2), true, fn(d, acc) ->
    if rem(x, d) == 0, do: {:halt, false}, else: {:cont, acc}
  end)
end
```

24. DFS

25. Pattern Matching
