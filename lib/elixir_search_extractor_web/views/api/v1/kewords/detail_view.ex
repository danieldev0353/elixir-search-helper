defmodule ElixirSearchExtractorWeb.Api.V1.Keywords.DetailView do
  use JSONAPI.View, type: "keyword"

  def fields do
    [
      :title,
      :inserted_at,
      :result_count,
      :result_urls,
      :top_ads_count,
      :top_ads_urls,
      :total_ads_count,
      :total_links_count,
      :status,
      :html
    ]
  end
end
