defmodule ElixirSearchExtractor.FileUpload.CsvUploaderTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.{AccountsFixtures, KeywordFileFixtures}
  alias ElixirSearchExtractor.FileUpload.CsvUploader

  describe "upload_file/2" do
    test "valid data uploads a file" do
      user = user_fixture()
      csv = valid_csv_file()
      upload_path = CsvUploader.upload_file_path(user.id, csv)

      assert {:ok, _} = CsvUploader.upload_file(csv, upload_path)

      assert File.exists?(upload_path)

      remove_uploaded_files(user.id)
    end

    test "invalid data returns error with reason" do
      user = user_fixture()
      assert {:error, reason} = CsvUploader.upload_file(user.id, '')

      assert reason == "CSV upload failed. Please try again"
    end
  end

  describe "upload_file_path/2" do
    test "valid data returns the upload path" do
      user = user_fixture()
      csv = valid_csv_file()
      upload_path = CsvUploader.upload_file_path(user.id, csv)

      assert String.contains?(upload_path, "keyword_files/user_#{user.id}")
    end
  end
end
