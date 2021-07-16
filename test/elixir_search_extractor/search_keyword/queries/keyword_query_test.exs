defmodule ElixirSearchExtractor.SearchKeyword.Queries.KeywordQueryTest do
  use ExUnit.Case, async: true

  alias ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery

  describe "filter_keywords/2" do
    test "returns unmodified query if the second argument is nil" do
      query = "SELECT * FROM keyword_files"

      returned_query = KeywordQuery.filter_keywords(query, nil)

      assert returned_query == query
    end
  end
end
