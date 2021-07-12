defmodule ElixirSearchExtractor.FileUpload.CsvParserTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.{KeywordFixtures, KeywordFileFixtures}
  alias ElixirSearchExtractor.FileUpload.CsvParser

  describe "parse/1" do
    test "returns a list of keywords if a keyword_file record is given" do
      keyword_file = insert(:keyword_file, csv_file: "#{csv_directory()}/valid_keywords.csv")
      {:ok, keyword_list} = CsvParser.parse(keyword_file)

      assert keyword_list == keyword_list()
    end
  end
end
