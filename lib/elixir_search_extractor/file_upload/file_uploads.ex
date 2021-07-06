defmodule ElixirSearchExtractor.FileUpload.FileUploads do
  alias Ecto.Multi
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
         {:ok, upload_path} <- CsvUploader.upload_file_path(user_id, csv_file),
         {:ok, refactored_attributes} <- refactor_attributes(attributes, user_id, upload_path),
         {:ok, %{create_keyword_file: keyword_file}} <-
           Repo.transaction(create_and_upload_file_multi(csv_file, refactored_attributes)) do
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

  defp refactor_attributes(attributes, user_id, upload_file_path) do
    refactored_attributes =
      attributes
      |> Map.put("csv_file", upload_file_path)
      |> Map.put("user_id", user_id)

    {:ok, refactored_attributes}
  end
end
