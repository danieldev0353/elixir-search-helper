defmodule ElixirSearchExtractor.ElixirSearchExtractorWorker.CsvKeywordsProcessingWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.FileUpload.CsvParser
  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"file_record_id" => record_id}}) do
    file_record = Repo.get_by!(KeywordFile, %{id: record_id})

    with {:ok, keyword_list} <- CsvParser.parse(file_record),
         :ok <- SearchKeywords.store_keywords(keyword_list, file_record.id) do
      FileUploads.completed(file_record)
    end

    :ok
  end
end
