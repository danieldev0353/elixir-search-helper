defmodule ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery do
  import Ecto.Query
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  def user_keywords(user) do
    Keyword
    |> join(:inner, [k], kf in assoc(k, :keyword_file))
    |> where([_, kf], kf.user_id == ^user.id)
    |> order_by([k, _], desc: k.inserted_at)
  end
end
