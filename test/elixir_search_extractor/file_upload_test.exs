defmodule ElixirSearchExtractor.FileUploadTest do
  use ElixirSearchExtractor.DataCase

  import ElixirSearchExtractor.KeywordsFixtures
  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.FileUpload

  describe "keyword_files" do
    alias ElixirSearchExtractor.FileUpload.KeywordFile

    test "list_keyword_files/0 returns all keyword_files" do
      user = user_fixture()
      keyword_file = keyword_file_fixture(user.id)
      assert FileUpload.list_keyword_files() == [keyword_file]

      remove_uploaded_files(user.id)
    end

    test "create_keyword_file/2 with valid data creates a keyword_file" do
      user = user_fixture()

      assert {:ok, %KeywordFile{} = keyword_file} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(),
                 user.id
               )

      assert keyword_file.name == "Test File"

      remove_uploaded_files(user.id)
    end

    test "create_keyword_file/2 with invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"name" => nil, "csv_file" => valid_csv_file()}),
                 user.id
               )
    end

    test "create_keyword_file/2 with invalid CSV exceeding 1MB in size returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => large_csv_file()}),
                 user.id
               )

      assert reason == "File size must me less than 1MB!"
    end

    test "create_keyword_file/2 with no file given returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => nil}),
                 user.id
               )

      assert reason == "A CSV file must be uploaded!"
    end

    test "create_keyword_file/2 with file with invalid extension returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => invalid_extension_file()}),
                 user.id
               )

      assert reason == "File must be a CSV!"
    end

    test "change_keyword_file/1 returns a keyword_file changeset" do
      user = user_fixture()
      keyword_file = keyword_file_fixture(user.id)
      assert %Ecto.Changeset{} = FileUpload.change_keyword_file(keyword_file)

      remove_uploaded_files(user.id)
    end
  end
end
