defmodule ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery do
  import Ecto.Query
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  def user_keywords(user) do
    Keyword
    |> join(:inner, [k], kf in assoc(k, :keyword_file))
    |> where([_, kf], kf.user_id == ^user.id)
    |> order_by([k, _], desc: k.inserted_at)
  end

  def user_keyword(user, keyword_id) do
    Keyword
    |> join(:inner, [k], kf in assoc(k, :keyword_file))
    |> where([k, kf], k.id == ^keyword_id and kf.user_id == ^user.id)
  end

  def filter_keywords(query, nil), do: query

  def filter_keywords(query, search_string) do
    where(query, [keyword], ilike(keyword.title, ^"%#{search_string}%"))
  end
end
