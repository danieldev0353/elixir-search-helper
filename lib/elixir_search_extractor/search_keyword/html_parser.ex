defmodule ElixirSearchExtractor.SearchKeyword.HtmlParser do
  @selector_mapping %{
    top_ads_count: "#tads .uEierd",
    top_ads_urls: "#tads .Krnil",
    total_ads_count: ".Krnil",
    result_urls: ".yuRUbf > a",
    total_result: ".yuRUbf",
    total_links_count: "a[href]"
  }

  def parse(html) do
    {_, document} = Floki.parse_document(html)

    %{
      top_ads_count: top_ads_count(document),
      top_ads_urls: top_ads_urls(document),
      total_ads_count: total_ads_count(document),
      result_count: result_count(document),
      result_urls: result_urls(document),
      total_links_count: total_links_count(document),
      html: html
    }
  end

  defp total_links_count(document) do
    document
    |> Floki.find(@selector_mapping.total_links_count)
    |> Enum.count()
  end

  defp result_count(document) do
    document
    |> Floki.find(@selector_mapping.total_result)
    |> Enum.count()
  end

  defp result_urls(document) do
    document
    |> Floki.find(@selector_mapping.result_urls)
    |> Floki.attribute("href")
  end

  defp top_ads_count(document) do
    document
    |> Floki.find(@selector_mapping.top_ads_count)
    |> Enum.count()
  end

  defp top_ads_urls(document) do
    document
    |> Floki.find(@selector_mapping.top_ads_urls)
    |> Floki.attribute("href")
  end

  defp total_ads_count(document) do
    document
    |> Floki.find(@selector_mapping.top_ads_urls)
    |> Enum.count()
  end
end
