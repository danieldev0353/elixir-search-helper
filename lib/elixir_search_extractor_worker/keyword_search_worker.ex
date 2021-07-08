defmodule ElixirSearchExtractorWorker.KeywordSearchWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.GoogleSearcher
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword_record = Repo.get_by!(Keyword, %{id: keyword_id})

    with {:ok, attributes} <- GoogleSearcher.search(keyword_record),
         :ok <- SearchKeywords.update_keyword(keyword_record, attributes) do
      SearchKeywords.completed(keyword_record)
    end

    :ok
  end
end
