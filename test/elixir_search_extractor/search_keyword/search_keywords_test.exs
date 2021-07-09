defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywordsTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordFixtures
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  describe "store_keywords/2" do
    test "with valid data creates keywords from the given keyword list" do
      keyword_file = insert(:keyword_file)

      assert {:ok, _} = SearchKeywords.store_keywords(keyword_list(), keyword_file.id)

      assert [keyword1, keyword2, keyword3, keyword4] = Repo.all(Keyword)

      assert keyword1.title == "GPS"
      assert keyword2.title == "Monitor"
      assert keyword3.title == "Laptop"
      assert keyword4.title == "Macbook"
    end

    test "does not create data if empty keyword list is given" do
      keyword_file = insert(:keyword_file)

      assert {:ok, []} = SearchKeywords.store_keywords([], keyword_file.id)

      assert [] = Repo.all(Keyword)
    end

    test "with invalid data raises KeywordNotCreatedError" do
      assert_raise ElixirSearchExtractor.SearchKeywords.Errors.KeywordNotCreatedError, fn ->
        SearchKeywords.store_keywords([""], "")
      end
    end
  end

  describe "update_keyword/2" do
    test "with valid data updates the keyword record" do
      keyword = insert(:keyword)

      assert :ok = SearchKeywords.update_keyword(keyword, update_attributes())
      updated_keyword = Repo.reload(keyword)

      assert updated_keyword.html == "some updated html"
      assert updated_keyword.result_count == 43
      assert updated_keyword.result_urls == []
      assert updated_keyword.status == :completed
      assert updated_keyword.top_ads_count == 43
      assert updated_keyword.top_ads_urls == []
      assert updated_keyword.total_ads_count == 43
      assert updated_keyword.total_links_count == 43
    end

    test "with invalid data raises KeywordNotUpdatedError" do
      keyword = insert(:keyword)

      assert_raise ElixirSearchExtractor.SearchKeywords.Errors.KeywordNotUpdatedError, fn ->
        SearchKeywords.update_keyword(keyword, invalid_attributes())
      end
    end
  end

  describe "mark_keyword_as_completed/1" do
    test "changes the keyword status to completed" do
      keyword = insert(:keyword)

      assert changeset = SearchKeywords.mark_keyword_as_completed(keyword)

      assert changeset.status == :completed
    end
  end
end
