defmodule ElixirSearchExtractor.KeywordFileFixtures do
  def valid_file_name, do: "Test File"
  def csv_directory, do: "#{File.cwd!()}/test/support/fixtures/csv_files"

  def valid_csv_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{csv_directory()}/valid_keywords.csv",
      filename: "valid.csv"
    }

  def large_csv_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{csv_directory()}/large_file.csv",
      filename: "large.csv"
    }

  def invalid_extension_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{csv_directory()}/invalid_extension.png",
      filename: "invalid.png"
    }

  def valid_keyword_file_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      "name" => valid_file_name(),
      "csv_file" => valid_csv_file()
    })
  end

  def remove_uploaded_files(user_id) do
    File.rm_rf("#{File.cwd!()}/keyword_files/user_#{user_id}/")
  end
end
