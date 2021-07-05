defmodule ElixirSearchExtractorWorker.CsvParserWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.FileUpload.CsvParser

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"file_record_id" => record_id} = args}) do
    file_record = Repo.get_by!(KeywordFile, %{id: record_id})
    :ok
  end
end
