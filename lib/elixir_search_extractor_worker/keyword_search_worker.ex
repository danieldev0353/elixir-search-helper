defmodule ElixirSearchExtractorWorker.KeywordSearchWorker do
  use Oban.Worker
  alias ElixirSearchExtractor.Repo
  alias ElixirSearchExtractor.SearchKeyword.{GoogleSearcher, HtmlParser, SearchKeywords}
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"keyword_id" => keyword_id}}) do
    keyword_record = Repo.get_by!(Keyword, %{id: keyword_id})

    with {:ok, response_body} <- GoogleSearcher.search(keyword_record),
         {:ok, attributes} <- HtmlParser.parse(response_body),
         :ok <- SearchKeywords.update_keyword(keyword_record, attributes) do
      SearchKeywords.mark_keyword_as_completed(keyword_record)
    end

    :ok
  end
end
