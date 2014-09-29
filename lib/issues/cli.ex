defmodule Issues.CLI do
  @default_count 4

  def run(argv) do
    argv
      |> parse_args
      |> process
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

  def process(:help) do
    IO.puts """
    NAME
      issues - the github issues fetcher

    SYNOPSIS
      issues [--help] [-h] <username> <project> [<count> | #{@default_count}]

    DESCRIPTION
      Issues will fetch the latest issues from a particular Github project.  Specify a Github <username> and <project> to fetch the latest issues.  Specifying a <count> will fetch that number of issues but it will default to 4.

    OPTIONS
      --help, -h
          Prints this manual page
    """
    System.halt(0)
  end

  def process({user, project, issue_count}) do
    Issues.GithubIssues.fetch(user, project)
      |> Issues.Parser.parse
      |> Issues.Filter.filter(issue_count)
      |> Issues.Reporter.response
      |> respond
  end

  def respond({ :error, response }) do
    IO.puts(response)
    System.halt(1)
  end

  def respond({ :ok, response }) do
    IO.puts(response)
    System.halt(0)
  end
end
