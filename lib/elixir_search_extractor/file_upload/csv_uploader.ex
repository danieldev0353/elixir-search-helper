defmodule ElixirSearchExtractor.FileUpload.CsvUploader do
  import Ecto.Query, warn: false

  # sobelow_skip ["Traversal"]
  def upload_file(user_id, csv) do
    File.mkdir_p!(Path.dirname(upload_directory(user_id)))
    upload_path = upload_file_path(user_id, csv)
    File.cp_r(csv.path, upload_path)

    {:ok, upload_path}
  rescue
    _ ->
      {:error, "CSV upload failed. Please try again"}
  end

  # sobelow_skip ["Traversal"]
  def remove_uploaded_file(file_path) do
    File.rm_rf(file_path)
  end

  defp upload_directory(user_id) do
    "#{File.cwd!()}/keyword_files/user_#{user_id}/"
  end

  defp upload_file_path(user_id, csv) do
    "#{upload_directory(user_id)}#{DateTime.to_unix(DateTime.utc_now())}-#{csv.filename}"
  end
end
