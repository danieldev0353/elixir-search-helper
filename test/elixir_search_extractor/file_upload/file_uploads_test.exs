defmodule ElixirSearchExtractor.FileUpload.FileUploadsTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordFileFixtures
  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile

  describe "paginated_user_keyword_files/2" do
    test "returns only user's keyword_files" do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      insert(:keyword_file)

      {keywords, _} = FileUploads.paginated_user_keyword_files(user, %{page: 1})

      assert length(keywords) == 1

      assert List.first(keywords).id == user_file.id
    end
  end

  describe "create_keyword_file/2 " do
    test "valid data creates a keyword_file" do
      user = user_fixture()

      assert {:ok, %KeywordFile{} = keyword_file} =
               FileUploads.create_keyword_file(
                 valid_keyword_file_attributes(),
                 user.id
               )

      assert keyword_file.name == "Test File"

      remove_uploaded_files(user.id)
    end

    test "invalid data returns error changeset" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FileUploads.create_keyword_file(
                 valid_keyword_file_attributes(%{"name" => nil, "csv_file" => valid_csv_file()}),
                 user.id
               )
    end

    test "invalid CSV exceeding 1MB in size returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUploads.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => large_csv_file()}),
                 user.id
               )

      assert reason == "File size must be less than 1MB!"
    end

    test "returns error with reason when no file is given" do
      user = user_fixture()

      assert {:error, reason} =
               FileUploads.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => nil}),
                 user.id
               )

      assert reason == "A CSV file must be uploaded!"
    end

    test "file with invalid extension returns error with reason" do
      user = user_fixture()

      assert {:error, reason} =
               FileUploads.create_keyword_file(
                 valid_keyword_file_attributes(%{"csv_file" => invalid_extension_file()}),
                 user.id
               )

      assert reason == "File must be a CSV!"
    end
  end

  describe "change_keyword_file/1 " do
    test "returns a keyword_file changeset" do
      keyword_file = insert(:keyword_file)

      assert %Ecto.Changeset{} = FileUploads.change_keyword_file(keyword_file)
    end
  end

  describe "completed/1" do
    test "changes the keyword status to completed" do
      keyword_file = insert(:keyword_file)

      assert changeset = FileUploads.completed(keyword_file)

      assert changeset.status == :completed
    end
  end
end
