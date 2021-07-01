defmodule ElixirSearchExtractor.FileUpload do
  import Ecto.Query, warn: false

  alias ElixirSearchExtractor.FileUpload.CsvUploader
  alias ElixirSearchExtractor.FileUpload.CsvValidator
  alias ElixirSearchExtractor.FileUpload.KeywordFile
  alias ElixirSearchExtractor.Repo

  def list_keyword_files do
    Repo.all(KeywordFile)
  end

  def create_keyword_file(attributes, user_id) do
    csv_file = attributes["csv_file"]

    with :ok <- CsvValidator.validate_file(csv_file),
         {:ok, upload_file_path} <- CsvUploader.upload_file(user_id, csv_file),
         {:ok, refactored_attributes} <-
           refactor_attributes(attributes, user_id, upload_file_path),
         {:ok, changeset} <- create_record(refactored_attributes) do
      validate_changeset(changeset)
    else
      {:error, reason} -> {:error, reason}
    end
  end

  defp refactor_attributes(attributes, user_id, upload_file_path) do
    refactored_attributes =
      attributes
      |> Map.put("csv_file", upload_file_path)
      |> Map.put("user_id", user_id)

    {:ok, refactored_attributes}
  end

  defp create_record(attributes) do
    changeset =
      %KeywordFile{}
      |> KeywordFile.changeset(attributes)
      |> Repo.insert()

    {:ok, changeset}
  end

  def change_keyword_file(%KeywordFile{} = keyword_file, attrs \\ %{}) do
    KeywordFile.changeset(keyword_file, attrs)
  end

  defp validate_changeset({status, attributes_data} = changeset) do
    case status do
      :error ->
        CsvUploader.remove_uploaded_file(attributes_data.changes.csv_file)

      _ ->
        nil
    end

    changeset
  end
end
