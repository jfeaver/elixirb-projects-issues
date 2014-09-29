defmodule Issues.Reporter do
  @vertical_border " | "
  @horizontal_border "---"
  @intersect_border "-+-"

  def response({ :error, body }) do
    { :error, "Repository does not exist" }
  end

  def response({ :ok, issues }) do
    { :ok, format_okay_response(issues) }
  end

  def format_okay_response( issues ) do
    issues
      |> collect_columns_data
      |> calculate_column_widths
      |> collect_rows
      |> Enum.join("\n")
  end

  def collect_columns_data( issues ) do
    issue_data_keys
      |> Enum.map( &({&1, %{ heading: headings[&1] }}) )
      |> Enum.map( &(add_issue_data(issues, &1)) )
      |> Enum.map( fn({_key, columns_data}) -> columns_data end )
  end

  def add_issue_data( issues, {key, columns_data} ) do
    issue_data = issue_data(key, issues)
    columns_data = Dict.put(columns_data, :data, issue_data)
    {key, columns_data}
  end

  def issue_data( key, issues ) do
    issues
      |> Enum.map( &(&1[key]) )
  end

  def calculate_column_widths( columns_data ) do
    columns_data
      |> Enum.map( &({ max_width(&1), &1 }) )
  end

  def max_width( column ) do
    column[:data]
      |> Enum.map( &(String.length(to_string(&1))) )
      |> Enum.max
  end

  def collect_rows( columns_data ) do
    [ heading_row(columns_data), border_row(columns_data) ] ++ issue_rows( columns_data )
  end

  def heading_row( columns_data ) do
    columns_data
      |> Enum.map( fn({ width, column_data }) ->
                     {column_data[:heading], width}
                   end )
      |> row
  end

  def border_row( columns_data ) do
    columns_data
      |> Enum.map( fn({ width, _column_data }) ->
                     {String.duplicate(@horizontal_border, width), width}
                   end )
      |> row( @intersect_border )
  end

  def issue_rows( columns_data ) do
    columns_data
      |> Enum.map( fn({ width, column_data }) ->
                     include_width_with_issue_column_data( column_data[:data], width )
                   end )
      |> List.zip
      |> Enum.map( &(Tuple.to_list(&1)) )
      |> Enum.map( &(row(&1)) )
  end

  def include_width_with_issue_column_data( data, width ) do
    data
      |> Enum.map( &({ &1, width }) )
  end

  def issue_data_keys, do: ~w(number created_at title)
  def headings, do: %{"number" => "#", "created_at" => "Created At", "title" => "Title"}

  def row( row_data, joiner \\ @vertical_border ) do
    row_data
      |> Enum.map( fn({content, width}) -> cell(content, width) end )
      |> Enum.join(joiner)
  end

  def cell( content, width ), do: to_string(:io_lib.format("~-#{width}s", [to_string(content)]))
end
