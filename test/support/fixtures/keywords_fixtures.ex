defmodule ElixirSearchExtractor.KeywordsFixtures do
  def valid_file_name, do: "Test File"

  def valid_csv_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{File.cwd!()}/test/support/fixtures/csv_files/valid_keywords.csv",
      filename: "valid.csv"
    }

  def large_csv_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{File.cwd!()}/test/support/fixtures/csv_files/large_file.csv",
      filename: "large.csv"
    }

  def invalid_extension_file,
    do: %Plug.Upload{
      content_type: "text/csv",
      path: "#{File.cwd!()}/test/support/fixtures/csv_files/invalid_extension.png",
      filename: "invalid.png"
    }

  def valid_keyword_file_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      "name" => valid_file_name(),
      "csv_file" => valid_csv_file()
    })
  end

  def keyword_file_fixture(user_id, attrs \\ %{}) do
    {:ok, keyword_file} =
      attrs
      |> valid_keyword_file_attributes()
      |> ElixirSearchExtractor.FileUpload.create_keyword_file(user_id)

    keyword_file
  end

  def remove_uploaded_files(user_id) do
    File.rm_rf("#{File.cwd!()}/keyword_files/user_#{user_id}/")
  end
end
