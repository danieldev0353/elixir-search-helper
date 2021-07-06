defmodule ElixirSearchExtractor.ElixirSearchExtractorWorker.KeywordSearchWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.GoogleSearcher
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword_record = Repo.get_by!(Keyword, %{id: keyword_id})

    with :ok <- GoogleSearcher.initiate_search(keyword_record) do
      SearchKeywords.completed(keyword_record)
    end

    :ok
  end
end
