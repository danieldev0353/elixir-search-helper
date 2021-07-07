defmodule ElixirSearchExtractorWorker.CsvKeywordsProcessingWorker do
  use ElixirSearchExtractor.DataCase, async: true

  alias ElixirSearchExtractor.ElixirSearchExtractorWorker.CsvKeywordsProcessingWorker
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  describe "perform/1" do
    test "creates the keywords from csv file record" do
      keyword_file = insert(:keyword_file)
      CsvKeywordsProcessingWorker.perform(%Oban.Job{args: %{"file_record_id" => keyword_file.id}})

      assert [keyword1, keyword2, keyword3, keyword4] = Repo.all(Keyword)

      assert keyword1.title == "GPS"
      assert keyword2.title == "Monitor"
      assert keyword3.title == "Laptop"
      assert keyword4.title == "Macbook"
    end

    test "updates the csv file record status to completed" do
      keyword_file = insert(:keyword_file)
      CsvKeywordsProcessingWorker.perform(%Oban.Job{args: %{"file_record_id" => keyword_file.id}})
      updated_keyword_file = Repo.reload(keyword_file)

      assert updated_keyword_file.status == :completed
    end
  end
end
