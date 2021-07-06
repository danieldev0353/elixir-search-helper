defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywords do
  alias ElixirSearchExtractor.ElixirSearchExtractorWorker.KeywordSearchWorker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeywords.Errors.KeywordNotCreatedError
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  def list_keywords do
    Repo.all(Keyword)
  end

  def save_keyword(keyword, keyword_file_id) do
    case create_keyword(%{
           title: keyword,
           keyword_file_id: keyword_file_id
         }) do
      {:ok, changeset} ->
        initiate_searcher(changeset)

      {:error, changeset} ->
        raise KeywordNotCreatedError, message: changeset
    end
  end

  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

  def completed(keyword) do
    keyword
    |> Keyword.complete_changeset()
    |> Repo.update!()
  end

  defp create_keyword(attrs) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  defp initiate_searcher(changeset) do
    %{keyword_id: changeset.id}
    |> KeywordSearchWorker.new()
    |> Oban.insert()

    :ok
  end
end
