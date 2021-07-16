defmodule ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery do
  import Ecto.Query
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  def user_keywords(user) do
    Keyword
    |> join(:inner, [k], kf in assoc(k, :keyword_file))
    |> where([_, kf], kf.user_id == ^user.id)
    |> order_by([k, _], desc: k.inserted_at)
  end

  def filter(query, params) do
    filtered_params = filter_empty_params(params)

    query
    |> filter_keywords(filtered_params["name"])
    |> filter_url(params["result_url"])
    |> filter_result_count(filtered_params["result_condition"], filtered_params["result_count"])
    |> filter_link_count(filtered_params["link_condition"], filtered_params["link_count"])
  end

  defp filter_empty_params(nil), do: nil

  defp filter_empty_params(params) do
    params
    |> Enum.filter(fn {_key, value} -> value !== "" end)
    |> Enum.into(%{})
  end

  defp filter_keywords(query, nil), do: query

  defp filter_keywords(query, search_string) do
    where(query, [keyword], ilike(keyword.title, ^"%#{search_string}%"))
  end

  defp filter_url(query, nil), do: query

  defp filter_url(query, search_string) do
    where(
      query,
      [keyword],
      fragment(
        "exists (select * from unnest(?) url where url like ?)",
        keyword.result_urls,
        ^"%#{search_string}%"
      )
    )
  end

  defp filter_result_count(query, condition, count) when is_nil(condition) or is_nil(count),
    do: query

  defp filter_result_count(query, condition, count) do
    case condition do
      ">" -> where(query, [keyword], keyword.result_count > ^count)
      "<" -> where(query, [keyword], keyword.result_count < ^count)
      "=" -> where(query, [keyword], keyword.result_count == ^count)
      _ -> query
    end
  end

  defp filter_link_count(query, condition, count) when is_nil(condition) or is_nil(count),
    do: query

  defp filter_link_count(query, condition, count) do
    case condition do
      ">" -> where(query, [keyword], keyword.total_links_count > ^count)
      "<" -> where(query, [keyword], keyword.total_links_count < ^count)
      "=" -> where(query, [keyword], keyword.total_links_count == ^count)
      _ -> query
    end
  end
end
