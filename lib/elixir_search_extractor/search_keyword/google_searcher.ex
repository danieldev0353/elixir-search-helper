defmodule ElixirSearchExtractor.SearchKeyword.GoogleSearcher do
  alias ElixirSearchExtractor.SearchKeyword.HtmlParser
  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords

  @user_agent "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.447"
  @google_search_url "https://www.google.com/search"

  def initiate_search(keyword) do
    response = make_request(keyword.title)
    attributes = HtmlParser.parse(response.body)
    SearchKeywords.update_keyword(keyword, attributes)

    :ok
  end

  defp make_request(keyword) do
    keyword
    |> build_url()
    |> HTTPoison.get!(headers())
  end

  defp headers do
    ["User-Agent": @user_agent]
  end

  defp build_url(keyword) do
    @google_search_url
    |> URI.parse()
    |> Map.put(:query, URI.encode_query(q: keyword, hl: "en", lr: "lang_on"))
    |> URI.to_string()
  end
end
