defmodule ElixirSearchExtractorWorker.KeywordParseWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.FileUpload.{CsvParser, FileUploads}
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_file_id" => keyword_file_id}}) do
    keyword_file = Repo.get_by!(KeywordFile, %{id: keyword_file_id})

    with {:ok, keyword_list} <- CsvParser.parse(keyword_file),
         :ok <- SearchKeywords.store_keywords(keyword_list, keyword_file.id) do
      FileUploads.mark_keyword_file_as_completed(keyword_file)
    end

    :ok
  end
end
