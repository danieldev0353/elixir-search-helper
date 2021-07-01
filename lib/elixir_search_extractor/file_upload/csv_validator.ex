defmodule ElixirSearchExtractor.FileUpload.CsvValidator do
  import Ecto.Query, warn: false

  def validate_file(csv) do
    with :ok <- validate_file_presence(csv),
         :ok <- validate_file_size(csv),
         :ok <- validate_extension(csv) do
      :ok
    end
  end

  defp validate_file_presence(csv) do
    case csv do
      nil -> {:error, "A CSV file must be uploaded!"}
      _ -> :ok
    end
  end

  defp validate_file_size(file) do
    %{size: file_size} = File.stat!(file.path)
    size_in_mb = file_size / 1_000_000

    case size_in_mb do
      size when size > 1 -> {:error, "File size must be less than 1MB!"}
      _ -> :ok
    end
  end

  defp validate_extension(file) do
    extension = Path.extname(file.filename)

    case extension do
      ext when ext !== ".csv" -> {:error, "File must be a CSV!"}
      _ -> :ok
    end
  end
end
