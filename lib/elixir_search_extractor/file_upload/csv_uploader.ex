defmodule ElixirSearchExtractor.FileUpload.CsvUploader do
  # sobelow_skip ["Traversal"]
  def upload_file(csv, upload_path) do
    File.cp_r(csv.path, upload_path)

    {:ok, upload_path}
  rescue
    _ ->
      {:error, "CSV upload failed. Please try again"}
  end

  def upload_file_path(user_id, csv) do
    "#{upload_directory(user_id)}#{DateTime.to_unix(DateTime.utc_now())}-#{csv.filename}"
  end

  # sobelow_skip ["Traversal"]
  defp upload_directory(user_id) do
    directory = "#{File.cwd!()}/keyword_files/user_#{user_id}/"
    File.mkdir_p!(Path.dirname(directory))

    directory
  end
end
