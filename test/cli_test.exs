defmodule CLITest do
  use ExUnit.Case
  import Issues.CLI, only: [parse_args: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert(parse_args(["-h"]) == :help)
    assert(parse_args(["--help"]) == :help)
  end

  test "three values returned if three given" do
    count = parse_args(["jfeaver", "elixirb", "7"])
      |> tuple_size
    assert(count == 3)
  end

  test "count returned is integer if given" do
    { _, _, n } = parse_args(["jfeaver", "elixirb", "7"])
    assert is_integer n
  end

  test "count is defaulted if two values given" do
    { _, _, n } = parse_args(["jfeaver", "elixirb"])
    assert is_integer n
  end
end
