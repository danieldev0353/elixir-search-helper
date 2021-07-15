defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywordsTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.{AccountsFixtures, KeywordFixtures}
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  describe "paginated_user_keywords/2" do
    test "returns user's keywords" do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      user_keyword = insert(:keyword, keyword_file: user_file)
      _other_user_keyword = insert(:keyword)

      {keyword, _} = SearchKeywords.paginated_user_keywords(user, %{page: 1})

      assert length(keyword) == 1

      assert List.first(keyword).id == user_keyword.id
    end

    test "returns filtered user's keywords if user search by keyword title" do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      searched_keyword = insert(:keyword, title: "Macbook", keyword_file: user_file)
      insert(:keyword, title: "GPS", keyword_file: user_file)

      {keyword, _} = SearchKeywords.paginated_user_keywords(user, %{"page" => 1, "name" => "Mac"})

      assert length(keyword) == 1

      assert List.first(keyword).id == searched_keyword.id
    end
  end

  describe "get_keyword!/1" do
    test "returns the keyword if the keyword exists" do
      keyword = insert(:keyword)
      retrieved_keyword = SearchKeywords.get_keyword!(keyword.id)

      assert retrieved_keyword.id == keyword.id
    end

    test "raises Ecto.NoResultsError if the keyword does not exists" do
      assert_raise Ecto.NoResultsError, fn ->
        SearchKeywords.get_keyword!(1)
      end
    end
  end

  describe "get_user_keyword/2" do
    test "returns the user keyword if the keyword exists" do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      user_keyword = insert(:keyword, keyword_file: user_file)

      retrieved_keyword = SearchKeywords.get_user_keyword(user, user_keyword.id)

      assert retrieved_keyword.id == user_keyword.id
    end

    test "returns nil if the user keyword does not exists" do
      user = user_fixture()

      assert nil == SearchKeywords.get_user_keyword(user, 1)
    end
  end

  describe "store_keywords!/2" do
    test "with valid data creates keywords from the given keyword list" do
      keyword_file = insert(:keyword_file)

      assert {:ok, _} = SearchKeywords.store_keywords!(keyword_list(), keyword_file.id)

      assert [keyword1, keyword2, keyword3, keyword4] = Repo.all(Keyword)

      assert keyword1.title == "GPS"
      assert keyword2.title == "Monitor"
      assert keyword3.title == "Laptop"
      assert keyword4.title == "Macbook"
    end

    test "does not create data if empty keyword list is given" do
      keyword_file = insert(:keyword_file)

      assert {:ok, []} = SearchKeywords.store_keywords!([], keyword_file.id)

      assert [] = Repo.all(Keyword)
    end

    test "with invalid data raises KeywordNotCreatedError" do
      assert_raise ElixirSearchExtractor.SearchKeyword.Errors.KeywordNotCreatedError, fn ->
        SearchKeywords.store_keywords!([""], "")
      end
    end
  end

  describe "update_keyword!/2" do
    test "with valid data updates the keyword record" do
      keyword = insert(:keyword)

      assert :ok = SearchKeywords.update_keyword!(keyword, update_attributes())
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

      assert_raise ElixirSearchExtractor.SearchKeyword.Errors.KeywordNotUpdatedError, fn ->
        SearchKeywords.update_keyword!(keyword, invalid_attributes())
      end
    end
  end

  describe "mark_keyword_as_completed!/1" do
    test "changes the keyword status to completed" do
      keyword = insert(:keyword)

      assert updated_keyword = SearchKeywords.mark_keyword_as_completed!(keyword)

      assert updated_keyword.status == :completed
    end
  end
end
