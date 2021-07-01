defmodule ElixirSearchExtractor.FileUploadTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordsFixtures
  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.FileUpload
  alias ElixirSearchExtractor.FileUpload.KeywordFile

  describe "list_keyword_files/0" do
    test "returns all keyword_files" do
      keyword_file = insert(:keyword_file)

      assert FileUpload.list_keyword_files() == [keyword_file]
    end
  end

  describe "create_keyword_file/2 " do
    test "valid data creates a keyword_file" do
      user = user_fixture()

      assert {:ok, %KeywordFile{} = keyword_file} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(),
                 user.id
               )

      assert keyword_file.name == "Test File"

      remove_uploaded_files(user.id)
    end

    test "invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"name" => nil, "csv_file" => valid_csv_file()}),
                 user.id
               )
    end

    test "invalid CSV exceeding 1MB in size returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => large_csv_file()}),
                 user.id
               )

      assert reason == "File size must be less than 1MB!"
    end

    test "returns error with reason when no file is given" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => nil}),
                 user.id
               )

      assert reason == "A CSV file must be uploaded!"
    end

    test "file with invalid extension returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUpload.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => invalid_extension_file()}),
                 user.id
               )

      assert reason == "File must be a CSV!"
    end
  end

  describe "change_keyword_file/1 " do
    test "returns a keyword_file changeset" do
      keyword_file = insert(:keyword_file)

      assert %Ecto.Changeset{} = FileUpload.change_keyword_file(keyword_file)
    end
  end
end
