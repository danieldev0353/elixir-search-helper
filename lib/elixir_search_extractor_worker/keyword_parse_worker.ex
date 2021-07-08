defmodule ElixirSearchExtractorWorker.KeywordParseWorker do
  use Oban.Worker

  alias Ecto.Multi
  alias ElixirSearchExtractor.FileUpload.{CsvParser, FileUploads}
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_file_id" => keyword_file_id}}) do
    keyword_file = Repo.get_by!(KeywordFile, %{id: keyword_file_id})

    with {:ok, keyword_list} <- CsvParser.parse(keyword_file),
         {:ok, _} <-
           Repo.transaction(
             store_keywords_and_complete_file_process_multi(keyword_list, keyword_file)
           ) do
      :ok
    end

    :ok
  end

  defp store_keywords_and_complete_file_process_multi(keyword_list, keyword_file) do
    Multi.new()
    |> Multi.run(:store_keyword, fn _, _ ->
      SearchKeywords.store_keywords(keyword_list, keyword_file.id)
    end)
    |> Multi.run(:mark_keyword_file_as_completed, fn _, _ ->
      FileUploads.mark_keyword_file_as_completed(keyword_file)
    end)
  end
end
