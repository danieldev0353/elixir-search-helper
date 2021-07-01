defmodule ElixirSearchExtractor.FileUpload.CsvUploaderTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordsFixtures
  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.FileUpload.CsvUploader

  describe "upload_file/2" do
    test "valid data uploads a file" do
      user = user_fixture()

      assert {:ok, upload_path} = CsvUploader.upload_file(user.id, valid_csv_file())

      assert File.exists?(upload_path)

      remove_uploaded_files(user.id)
    end

    test "invalid data returns error with reason" do
      user = user_fixture()
      assert {:error, reason} = CsvUploader.upload_file(user.id, '')

      assert reason == "CSV upload failed. Please try again"
    end
  end

  describe "remove_uploaded_file/1" do
    test "removes files from the given path" do
      user = user_fixture()
      {_, upload_path} = CsvUploader.upload_file(user.id, valid_csv_file())
      CsvUploader.remove_uploaded_file(upload_path)

      assert !File.exists?(upload_path)
    end
  end
end
