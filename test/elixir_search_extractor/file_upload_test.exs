defmodule ElixirSearchExtractor.FileUploadTest do
  use ElixirSearchExtractor.DataCase

  alias ElixirSearchExtractor.FileUpload

  describe "keyword_files" do
    alias ElixirSearchExtractor.FileUpload.KeywordFile

    @valid_attrs %{file_name: "some file_name", name: "some name"}
    @update_attrs %{file_name: "some updated file_name", name: "some updated name"}
    @invalid_attrs %{file_name: nil, name: nil}

    def keyword_file_fixture(attrs \\ %{}) do
      {:ok, keyword_file} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FileUpload.create_keyword_file()

      keyword_file
    end

    test "list_keyword_files/0 returns all keyword_files" do
      keyword_file = keyword_file_fixture()
      assert FileUpload.list_keyword_files() == [keyword_file]
    end

    test "get_keyword_file!/1 returns the keyword_file with given id" do
      keyword_file = keyword_file_fixture()
      assert FileUpload.get_keyword_file!(keyword_file.id) == keyword_file
    end

    test "create_keyword_file/1 with valid data creates a keyword_file" do
      assert {:ok, %KeywordFile{} = keyword_file} = FileUpload.create_keyword_file(@valid_attrs)
      assert keyword_file.file_name == "some file_name"
      assert keyword_file.name == "some name"
    end

    test "create_keyword_file/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FileUpload.create_keyword_file(@invalid_attrs)
    end

    test "update_keyword_file/2 with valid data updates the keyword_file" do
      keyword_file = keyword_file_fixture()
      assert {:ok, %KeywordFile{} = keyword_file} = FileUpload.update_keyword_file(keyword_file, @update_attrs)
      assert keyword_file.file_name == "some updated file_name"
      assert keyword_file.name == "some updated name"
    end

    test "update_keyword_file/2 with invalid data returns error changeset" do
      keyword_file = keyword_file_fixture()
      assert {:error, %Ecto.Changeset{}} = FileUpload.update_keyword_file(keyword_file, @invalid_attrs)
      assert keyword_file == FileUpload.get_keyword_file!(keyword_file.id)
    end

    test "delete_keyword_file/1 deletes the keyword_file" do
      keyword_file = keyword_file_fixture()
      assert {:ok, %KeywordFile{}} = FileUpload.delete_keyword_file(keyword_file)
      assert_raise Ecto.NoResultsError, fn -> FileUpload.get_keyword_file!(keyword_file.id) end
    end

    test "change_keyword_file/1 returns a keyword_file changeset" do
      keyword_file = keyword_file_fixture()
      assert %Ecto.Changeset{} = FileUpload.change_keyword_file(keyword_file)
    end
  end
end
