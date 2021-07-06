defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywords do
  alias ElixirSearchExtractor.ElixirSearchExtractorWorker.KeywordSearchWorker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeywords.Errors.KeywordNotCreatedError
  alias ElixirSearchExtractor.SearchKeywords.Errors.KeywordNotUpdatedError

  def list_keywords do
    Repo.all(Keyword)
  end

  def create_keyword(attributes) do
    case %Keyword{}
         |> Keyword.changeset(attributes)
         |> Repo.insert() do
      {:ok, changeset} ->
        initiate_searcher(changeset)

      {:error, changeset} ->
        raise KeywordNotCreatedError, message: changeset
    end
  end

  def update_keyword(%Keyword{} = keyword, attrs) do
    case keyword
         |> Keyword.changeset(attrs)
         |> Repo.update() do
      {:ok, _} ->
        :ok

      {:error, changeset} ->
        raise KeywordNotUpdatedError, message: changeset
    end
  end

  def completed(keyword) do
    keyword
    |> Keyword.complete_changeset()
    |> Repo.update!()
  end

  defp initiate_searcher(changeset) do
    %{keyword_id: changeset.id}
    |> KeywordSearchWorker.new()
    |> Oban.insert()

    :ok
  end
end
