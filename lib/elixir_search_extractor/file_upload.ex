defmodule ElixirSearchExtractor.FileUpload do
  import Ecto.Query, warn: false

  alias ElixirSearchExtractor.FileUpload.KeywordFile
  alias ElixirSearchExtractor.Repo

  def list_keyword_files do
    Repo.all(KeywordFile)
  end

  def create_keyword_file(attributes, user_id) do
    csv_file = attributes["csv_file"]

    case validate_file(csv_file) do
      {:ok} ->
        attributes = Map.put(attributes, "csv_file", upload_file_path(user_id, csv_file))
        attributes = Map.put(attributes, "user_id", user_id)

        %KeywordFile{}
        |> KeywordFile.changeset(attributes)
        |> Repo.insert()
        |> upload_file(user_id, csv_file)

      {:error, reason} ->
        {:error, reason}
    end
  end

  def change_keyword_file(%KeywordFile{} = keyword_file, attrs \\ %{}) do
    KeywordFile.changeset(keyword_file, attrs)
  end

  defp validate_file(csv) do
    with {:ok} <- validate_file_presence(csv),
         {:ok} <- validate_file_size(csv),
         {:ok} <- validate_extension(csv) do
      {:ok}
    else
      err -> err
    end
  end

  defp validate_file_presence(csv) do
    case csv do
      nil -> {:error, "A CSV file must be uploaded!"}
      _ -> {:ok}
    end
  end

  defp validate_file_size(file) do
    %{size: file_size} = File.stat!(file.path)
    size_in_mb = file_size / 1_000_000

    case size_in_mb do
      size when size > 1 -> {:error, "File size must me less than 1MB!"}
      _ -> {:ok}
    end
  end

  defp validate_extension(file) do
    extension = Path.extname(file.filename)

    case extension do
      ext when ext !== ".csv" -> {:error, "File must be a CSV!"}
      _ -> {:ok}
    end
  end

  # sobelow_skip ["Traversal"]
  defp upload_file({status, _} = changeset, user_id, csv) do
    case status do
      :ok ->
        File.mkdir_p!(Path.dirname(upload_directory(user_id)))
        File.cp_r(csv.path, upload_file_path(user_id, csv))

      _ ->
        nil
    end

    changeset
  end

  defp upload_directory(user_id) do
    "#{File.cwd!()}/keyword_files/user_#{user_id}/"
  end

  defp upload_file_path(user_id, csv) do
    "#{upload_directory(user_id)}#{DateTime.to_unix(DateTime.utc_now())}-#{csv.filename}"
  end
end
