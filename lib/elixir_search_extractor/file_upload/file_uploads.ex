defmodule ElixirSearchExtractor.FileUpload.FileUploads do
  alias Ecto.Multi
  alias ElixirSearchExtractor.ElixirSearchExtractorWorker.KeywordParseWorker
  alias ElixirSearchExtractor.FileUpload.{CsvUploader, CsvValidator, KeywordFile}
  alias ElixirSearchExtractor.FileUpload.Queries.KeywordFileQuery
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.Repo

  def paginated_user_keyword_files(user, params \\ %{}) do
    user
    |> KeywordFileQuery.user_keyword_files()
    |> Repo.paginate(params)
  end

  def create_keyword_file(attributes, user_id) do
    csv_file = attributes["csv_file"]

    with :ok <- CsvValidator.validate_file(csv_file),
         {:ok, refactored_attributes} <- refactor_attributes(attributes, user_id, csv_file),
         {:ok, %{create_keyword_file: keyword_file}} <-
           Repo.transaction(create_and_upload_file_multi(csv_file, refactored_attributes)),
         :ok <- enque_keyword_parsing_job(keyword_file) do
      {:ok, keyword_file}
    else
      {:error, :create_keyword_file, changeset, _} ->
        {:error, changeset}

      {:error, :upload_keyword_file, reason, _} ->
        {:error, reason}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def mark_keyword_file_as_completed(keyword_file) do
    keyword_file
    |> KeywordFile.complete_changeset()
    |> Repo.update!()
  end

  def change_keyword_file(%KeywordFile{} = keyword_file, attrs \\ %{}) do
    KeywordFile.changeset(keyword_file, attrs)
  end

  defp create_and_upload_file_multi(csv_file, attributes) do
    Multi.new()
    |> Multi.insert(:create_keyword_file, KeywordFile.changeset(%KeywordFile{}, attributes))
    |> Multi.run(:upload_keyword_file, fn _, _ ->
      CsvUploader.upload_file(csv_file, attributes["csv_file"])
    end)
  end

  defp refactor_attributes(attributes, user_id, csv_file) do
    upload_file_path = CsvUploader.upload_file_path(user_id, csv_file)

    refactored_attributes =
      attributes
      |> Map.put("csv_file", upload_file_path)
      |> Map.put("user_id", user_id)

    {:ok, refactored_attributes}
  end

  defp enque_keyword_parsing_job(keyword_file) do
    %{keyword_file_id: keyword_file.id}
    |> KeywordParseWorker.new()
    |> Oban.insert()

    :ok
  end
end
