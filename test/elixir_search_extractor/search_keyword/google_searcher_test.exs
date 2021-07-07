defmodule ElixirSearchExtractor.SearchKeyword.GoogleSearcherTest do
  use ElixirSearchExtractor.DataCase, async: true

  alias ElixirSearchExtractor.SearchKeyword.GoogleSearcher

  describe "search/1" do
    test "returns result attributes from google search result" do
      use_cassette "google_search_result" do
        keyword = insert(:keyword, title: "Macbook")

        assert {:ok, attributes} = GoogleSearcher.search(keyword)

        assert attributes.top_ads_count == 1
        assert attributes.top_ads_urls == ["https://www.apple.com/sg/mac/"]
        assert attributes.total_ads_count == 1
        assert attributes.result_count == 9
        assert Enum.count(attributes.result_urls) == 9
        assert attributes.total_links_count == 207
        assert String.contains?(attributes.html, "<!doctype html>")
      end
    end
  end
end
