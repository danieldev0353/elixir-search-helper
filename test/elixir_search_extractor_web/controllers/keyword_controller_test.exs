defmodule ElixirSearchExtractorWeb.KeywordControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  alias ElixirSearchExtractor.SearchKeywords

  @create_attrs %{html: "some html", result_count: 42, result_urls: [], status: 42, title: "some title", top_ads_count: 42, top_ads_urls: [], total_ads_count: 42, total_links_count: 42}
  @update_attrs %{html: "some updated html", result_count: 43, result_urls: [], status: 43, title: "some updated title", top_ads_count: 43, top_ads_urls: [], total_ads_count: 43, total_links_count: 43}
  @invalid_attrs %{html: nil, result_count: nil, result_urls: nil, status: nil, title: nil, top_ads_count: nil, top_ads_urls: nil, total_ads_count: nil, total_links_count: nil}

  def fixture(:keyword) do
    {:ok, keyword} = SearchKeywords.create_keyword(@create_attrs)
    keyword
  end

  describe "index" do
    test "lists all keywords", %{conn: conn} do
      conn = get(conn, Routes.keyword_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Keywords"
    end
  end
end
