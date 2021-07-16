defmodule ElixirSearchExtractorWeb.Api.V1.KeywordController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords
  alias ElixirSearchExtractorWeb.Api.V1.ErrorView
  alias ElixirSearchExtractorWeb.Api.V1.Keywords.{DetailView, ListView}

  def index(conn, params) do
    {keywords, pagination} =
      SearchKeywords.paginated_user_keywords(conn.assigns.current_user, params)

    conn
    |> put_view(ListView)
    |> render("index.json", data: keywords, meta: meta_data(pagination))
  end

  def show(conn, %{"id" => keyword_id}) do
    case SearchKeywords.get_user_keyword(conn.assigns.current_user, keyword_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> put_view(ErrorView)
        |> render("error.json", errors: "Keyword not found!")

      keyword ->
        conn
        |> put_view(DetailView)
        |> render("show.json", data: keyword)
    end
  end

  defp meta_data(pagination) do
    %{
      page: pagination.page,
      pages: pagination.total_pages,
      page_size: pagination.per_page,
      records: pagination.total_count
    }
  end
end
