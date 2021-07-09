defmodule ElixirSearchExtractorWorker.CsvKeywordsProcessingWorkerTest do
  use ElixirSearchExtractor.DataCase

  alias ElixirSearchExtractorWorker.KeywordSearchWorker

  describe "perform/1" do
    test "updates the keyword record with search results" do
      use_cassette "google_search_result" do
        keyword = insert(:keyword)
        KeywordSearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword.id}})
        updated_keyword = Repo.reload(keyword)

        assert updated_keyword.top_ads_count == 1
        assert updated_keyword.top_ads_urls == ["https://www.apple.com/sg/mac/"]
        assert updated_keyword.total_ads_count == 1
        assert updated_keyword.result_count == 9
        assert Enum.count(updated_keyword.result_urls) == 9
        assert updated_keyword.total_links_count == 207
        assert String.contains?(updated_keyword.html, "<!doctype html>")
      end
    end

    test "updates the keyword status to completed" do
      use_cassette "google_search_result" do
        keyword = insert(:keyword)
        KeywordSearchWorker.perform(%Oban.Job{args: %{"keyword_id" => keyword.id}})
        updated_keyword = Repo.reload(keyword)

        assert updated_keyword.status == :completed
      end
    end
  end
end
