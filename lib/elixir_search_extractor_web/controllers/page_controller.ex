defmodule ElixirSearchExtractorWeb.PageController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  def index(conn, params) do
    {keywords, pagination} =
      SearchKeywords.paginated_user_keywords(conn.assigns.current_user, params)

    render(conn, "index.html", keywords: keywords, pagination: pagination)
  end
end
