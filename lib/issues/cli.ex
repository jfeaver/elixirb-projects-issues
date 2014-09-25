defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    parse_args(argv)
  end

  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])

    case parse do
      {[help: true], _rem, _err} ->
        :help
      {_, [user, project, count], _} ->
        {user, project, String.to_integer(count)}
      {_, [user, project], _} ->
        {user, project, @default_count}
      _ -> :help
    end

  end
end
