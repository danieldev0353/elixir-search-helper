defmodule ElixirSearchExtractor.KeywordFixtures do
  def keyword_list, do: ["GPS", "Monitor", "Laptop", "Macbook"]

  def valid_attributes,
    do: %{
      html: "some html",
      result_count: 42,
      result_urls: [],
      status: :processing,
      title: "some title",
      top_ads_count: 42,
      top_ads_urls: [],
      total_ads_count: 42,
      total_links_count: 42
    }

  def update_attributes,
    do: %{
      html: "some updated html",
      result_count: 43,
      result_urls: [],
      status: :completed,
      top_ads_count: 43,
      top_ads_urls: [],
      total_ads_count: 43,
      total_links_count: 43
    }

  def invalid_attributes,
    do: %{
      html: nil,
      result_count: nil,
      result_urls: nil,
      status: nil,
      title: nil,
      top_ads_count: nil,
      top_ads_urls: nil,
      total_ads_count: nil,
      total_links_count: nil
    }
end
