defmodule ElixirSearchExtractor.SearchKeywordsTest do
  use ElixirSearchExtractor.DataCase

  alias ElixirSearchExtractor.SearchKeywords

  describe "keywords" do
    alias ElixirSearchExtractor.SearchKeywords.Keyword

    @valid_attrs %{html: "some html", result_count: 42, result_urls: [], status: 42, title: "some title", top_ads_count: 42, top_ads_urls: [], total_ads_count: 42, total_links_count: 42}
    @update_attrs %{html: "some updated html", result_count: 43, result_urls: [], status: 43, title: "some updated title", top_ads_count: 43, top_ads_urls: [], total_ads_count: 43, total_links_count: 43}
    @invalid_attrs %{html: nil, result_count: nil, result_urls: nil, status: nil, title: nil, top_ads_count: nil, top_ads_urls: nil, total_ads_count: nil, total_links_count: nil}

    def keyword_fixture(attrs \\ %{}) do
      {:ok, keyword} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SearchKeywords.create_keyword()

      keyword
    end

    test "list_keywords/0 returns all keywords" do
      keyword = keyword_fixture()
      assert SearchKeywords.list_keywords() == [keyword]
    end

    test "create_keyword/1 with valid data creates a keyword" do
      assert {:ok, %Keyword{} = keyword} = SearchKeywords.create_keyword(@valid_attrs)
      assert keyword.html == "some html"
      assert keyword.result_count == 42
      assert keyword.result_urls == []
      assert keyword.status == 42
      assert keyword.title == "some title"
      assert keyword.top_ads_count == 42
      assert keyword.top_ads_urls == []
      assert keyword.total_ads_count == 42
      assert keyword.total_links_count == 42
    end

    test "create_keyword/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SearchKeywords.create_keyword(@invalid_attrs)
    end

    test "update_keyword/2 with valid data updates the keyword" do
      keyword = keyword_fixture()
      assert {:ok, %Keyword{} = keyword} = SearchKeywords.update_keyword(keyword, @update_attrs)
      assert keyword.html == "some updated html"
      assert keyword.result_count == 43
      assert keyword.result_urls == []
      assert keyword.status == 43
      assert keyword.title == "some updated title"
      assert keyword.top_ads_count == 43
      assert keyword.top_ads_urls == []
      assert keyword.total_ads_count == 43
      assert keyword.total_links_count == 43
    end

    test "update_keyword/2 with invalid data returns error changeset" do
      keyword = keyword_fixture()
      assert {:error, %Ecto.Changeset{}} = SearchKeywords.update_keyword(keyword, @invalid_attrs)
      assert keyword == SearchKeywords.get_keyword!(keyword.id)
    end

  end
end
