defmodule ElixirSearchExtractor.SearchKeyword.GoogleSearcherTest do
  use ElixirSearchExtractor.DataCase

  alias ElixirSearchExtractor.SearchKeyword.GoogleSearcher

  describe "search/1" do
    test "returns result attributes from google search result" do
      use_cassette "google_search_result" do
        keyword = insert(:keyword, title: "Macbook")

        assert {:ok, html_body} = GoogleSearcher.search(keyword)

        assert String.contains?(html_body, "<!doctype html>")
      end
    end
  end
end
