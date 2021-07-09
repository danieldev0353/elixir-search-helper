defmodule ElixirSearchExtractor.SearchKeyword.SearchKeywords do
  alias Ecto.Multi
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeyword.Errors.{KeywordNotCreatedError, KeywordNotUpdatedError}
  alias ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery
  alias ElixirSearchExtractorWorker.KeywordSearchWorker

  def paginated_user_keywords(user, params \\ %{}) do
    user
    |> KeywordQuery.user_keywords()
    |> Repo.paginate(params)
  end

  def store_keywords!(keyword_list, keyword_file_id) do
    Enum.each(keyword_list, fn keyword ->
      case create_keyword_and_enqueue_search_multi(%{
             title: keyword,
             keyword_file_id: keyword_file_id
           }) do
        {:ok, _} ->
          :ok

        {:error, :create_keyword, changeset, _} ->
          raise KeywordNotCreatedError, message: changeset
      end
    end)

    {:ok, keyword_list}
  end

  def update_keyword!(%Keyword{} = keyword, attrs) do
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

  def mark_keyword_as_completed!(keyword) do
    keyword
    |> Keyword.complete_changeset()
    |> Repo.update!()
  end

  defp create_keyword_and_enqueue_search_multi(attributes) do
    Multi.new()
    |> Multi.insert(:create_keyword, Keyword.changeset(%Keyword{}, attributes))
    |> Multi.run(:enqueue_keyword_searching_job, fn _, %{create_keyword: keyword} ->
      enqueue_keyword_searching_job(keyword)
    end)
    |> Repo.transaction()
  end

  defp enqueue_keyword_searching_job(keyword) do
    %{keyword_id: keyword.id}
    |> KeywordSearchWorker.new(schedule_in: :rand.uniform(100))
    |> Oban.insert()

    {:ok, keyword}
  end
end
