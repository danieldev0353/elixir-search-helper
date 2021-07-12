defmodule ElixirSearchExtractor.FileUpload.Schemas.KeywordTest do
  use ElixirSearchExtractor.DataCase, async: true

  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  describe "changeset/2" do
    test "returns valid changeset if given valid attributes" do
      attributes = %{"keyword_file_id" => 1, "title" => "test"}
      changeset = Keyword.changeset(%Keyword{}, attributes)

      assert changeset.valid?
    end

    test "returns invalid changeset if given invalid attributes" do
      changeset = Keyword.changeset(%Keyword{}, %{})

      refute changeset.valid?

      assert errors_on(changeset) == %{
               title: ["can't be blank"],
               keyword_file_id: ["can't be blank"]
             }
    end
  end

  describe "complete_changeset/1" do
    test "updates keyword status to completed" do
      keyword = insert(:keyword)
      changeset = Keyword.complete_changeset(keyword)

      assert changeset.changes[:status] == :completed
    end
  end
end
