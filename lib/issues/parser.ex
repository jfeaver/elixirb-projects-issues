defmodule Issues.Parser do
  def parse({ status, body }) do
    {:ok, parsed_json} = JSEX.decode( body )
    { status, parsed_json }
  end
end
