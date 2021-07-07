defmodule ElixirSearchExtractor.FileUpload.Schemas.KeywordFileTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordFileFixtures
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile

  describe "changeset/2" do
    test "returns valid changeset if given valid attributes" do
      attributes = valid_keyword_file_attributes(%{"user_id" => 1, "csv_file" => "tmp/"})
      changeset = KeywordFile.changeset(%KeywordFile{}, attributes)

      assert changeset.valid?
    end

    test "returns invalid changeset if given invalid attributes" do
      changeset = KeywordFile.changeset(%KeywordFile{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               name: ["can't be blank"],
               csv_file: ["can't be blank"],
               user_id: ["can't be blank"]
             }
    end
  end

  describe "complete_changeset/1" do
    test "updates keyword_file status to completed" do
      keyword_file = insert(:keyword_file)
      changeset = KeywordFile.complete_changeset(keyword_file)

      assert changeset.changes[:status] == :completed
    end
  end
end
