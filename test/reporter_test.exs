defmodule ReporterTest do
  use ExUnit.Case
  import Issues.Reporter

  test "cell yields a formatted string" do
    assert( cell("hello", 10) == "hello     " )
  end

  def test_row do
    [
      { "hello", 10 },
      { "world", 10 }
    ]
  end
  @test_row_string "hello      | world     "

  test "row yields a formatted string" do
    assert( row( test_row ) == @test_row_string )
  end

  def test_issues do
    [
      %{ "number" => 1234, "created_at" => "2014-09-2T23:43:03Z", "title" => "hello world issue" },
      %{ "number" => 1235, "created_at" => "2014-09-2T21:43:03Z", "title" => "foobar issue" },
      %{ "number" => 1236, "created_at" => "2014-09-2T19:43:03Z", "title" => "this is a test issue" }
    ]
  end

  def columns_data do
    [
      %{ heading: "#", data: [1234, 1235, 1236] },
      %{ heading: "Created At", data: ~w(2014-09-2T23:43:03Z 2014-09-2T21:43:03Z 2014-09-2T19:43:03Z) },
      %{ heading: "Title", data: ["hello world issue", "foobar issue", "this is a test issue"] }
    ]
  end

  def final_columns_data do
    columns_data
      |> calculate_column_widths
  end

  test "issue_rows yields a list of rows" do
    the_rows = final_columns_data
      |> issue_rows
    assert( length(the_rows) == length( test_issues ) )
    hd(the_rows)
      |> String.match?(~r/hello world/)
      |> assert
  end

  test "collect_columns_data puts data into columns" do
    assert( collect_columns_data(test_issues) == columns_data )
  end

  test "calculate_column_widths generates the maximum column width needed" do
    title_columns_data = final_columns_data
      |> List.last
    longest_title_length = List.last(test_issues)["title"]
      |> String.length
    assert( match?({longest_title_length, _}, title_columns_data) )
  end

  test "heading_row generates a heading row" do
    assert(String.match?(heading_row( final_columns_data ), ~r/Created At/))
  end

  test "border_row generates a heading row" do
    assert(String.match?(border_row( final_columns_data ), ~r/-\+-/))
  end
end
