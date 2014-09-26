defmodule Issues.GithubIssues do
  @base_url "https://api.github.com/repos"

  def fetch(user, project) do
    raw_response(user, project)
      |> handle_response
      |> react
  end

  defp raw_response(user, project) do
    HTTPoison.get("#{@base_url}/#{user}/#{project}/issues")
  end

  defp handle_response(%{ status_code: 200, body: body}), do: { :ok, body }
  defp handle_response(%{ status_code: ___, body: body}), do: { :error, body }

  defp react({ :ok, body }) do
    body
  end
  defp react({ :error, body }), do: { :error, body }

end
