defmodule ElixirSearchExtractorWeb.KeywordController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  def html_view(conn, %{"keyword_id" => keyword_id}) do
    keyword = SearchKeywords.get_keyword!(keyword_id)

    render(conn, "html_view.html", keyword: keyword)
  end
end
