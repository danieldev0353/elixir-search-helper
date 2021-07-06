defmodule ElixirSearchExtractor.ElixirSearchExtractorWorker.CsvParserWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.FileUpload.CsvParser
  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.Repo

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"file_record_id" => record_id}}) do
    file_record = Repo.get_by!(KeywordFile, %{id: record_id})

    with :ok <- CsvParser.parse(file_record) do
      FileUploads.completed(file_record)
    end

    :ok
  end
end
