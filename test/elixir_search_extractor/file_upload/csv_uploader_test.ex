defmodule ElixirSearchExtractor.FileUpload.CsvUploaderTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordsFixtures
  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.FileUpload.CsvUploader

  describe "upload_file/2" do
    test "valid data uploads a file" do
      user = user_fixture()
      csv = valid_csv_file()
      {:ok, upload_path} = CsvUploader.upload_file_path(user.id, csv)

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

      assert {:ok, _} = CsvUploader.upload_file_path(user.id, csv)
    end
  end
end