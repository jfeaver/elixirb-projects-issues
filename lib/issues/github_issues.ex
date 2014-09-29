defmodule Issues.GithubIssues do
  @github_api Application.get_env(:issues, :github_api)

  def fetch(user, project) do
    raw_response(user, project)
      |> handle_response
  end

  defp raw_response(user, project) do
    HTTPoison.get(issues_endpoint(user, project))
  end
  defp issues_endpoint(user, project) do
    "#{@github_api}/repos/#{user}/#{project}/issues"
  end

  defp handle_response(%{ status_code: 200, body: body}), do: { :ok, body }
  defp handle_response(%{ status_code: ___, body: body}), do: { :error, body }
end
