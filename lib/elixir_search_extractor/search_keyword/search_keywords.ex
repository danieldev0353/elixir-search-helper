defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywords do
  alias ElixirSearchExtractorWorker.KeywordSearchWorker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeywords.Errors.{KeywordNotCreatedError, KeywordNotUpdatedError}

  def store_keywords(keyword_list, keyword_file_id) do
    Enum.each(keyword_list, fn keyword ->
      create_keyword_and_initiate_search(%{
        title: keyword,
        keyword_file_id: keyword_file_id
      })
    end)

    {:ok, keyword_list}
  end

  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
    |> case do
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

  defp create_keyword_and_initiate_search(attributes) do
    case %Keyword{}
         |> Keyword.changeset(attributes)
         |> Repo.insert() do
      {:ok, changeset} ->
        initiate_searcher(changeset)

      {:error, changeset} ->
        raise KeywordNotCreatedError, message: changeset
    end
  end

  defp initiate_searcher(changeset) do
    %{keyword_id: changeset.id}
    |> KeywordSearchWorker.new(schedule_in: :rand.uniform(100))
    |> Oban.insert()

    :ok
  end
end
