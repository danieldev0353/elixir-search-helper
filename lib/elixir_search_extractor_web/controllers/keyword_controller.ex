defmodule ElixirSearchExtractorWeb.KeywordController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.SearchKeywords
  alias ElixirSearchExtractor.SearchKeywords.Keyword

  def index(conn, _params) do
    keywords = SearchKeywords.list_keywords()
    render(conn, "index.html", keywords: keywords)
  end

end
