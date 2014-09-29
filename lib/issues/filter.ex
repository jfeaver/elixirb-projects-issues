defmodule Issues.Filter do
  def filter({ :ok, issues }, issue_count) do
    { :ok, filtered_issues( issues, issue_count ) }
  end

  # pass along any non ok response
  def filter(response, _) do
    response
  end

  def filtered_issues( issues, issue_count ) do
    issues
      |> sort
      |> Enum.take( issue_count )
  end

  def sort( issues ) do
    Enum.sort(issues,
      &( &1["created_at"] > &2["created_at"] ))
  end
end
