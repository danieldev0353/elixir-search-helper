defmodule ElixirSearchExtractor.SearchKeyword.HtmlParserTest do
  use ElixirSearchExtractor.DataCase, async: true

  alias ElixirSearchExtractor.SearchKeyword.HtmlParser

  @html_fixture "test/support/fixtures/html_files/google_response.html"

  describe "parse/1" do
    test "returns parsed data" do
      {_, html} = File.read(@html_fixture)

      assert {:ok, result} = HtmlParser.parse(html)

      assert result.top_ads_count == 1
      assert result.top_ads_urls == ["https://www.apple.com/sg/mac/"]
      assert result.total_ads_count == 1
      assert result.result_count == 8
      assert Enum.count(result.result_urls) == 8
      assert result.total_links_count == 288
      assert String.contains?(result.html, "<!DOCTYPE html>")
    end
  end
end
