defmodule ElixirSearchExtractor.SearchKeyword.Queries.KeywordQuery do
  import Ecto.Query
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile
  alias ElixirSearchExtractor.SearchKeyword.Schemas.Keyword

  def user_keywords(user) do
    from keyword in Keyword,
      join: file in KeywordFile,
      on: keyword.keyword_file_id == file.id,
      where: file.user_id == ^user.id,
      order_by: fragment("? DESC", keyword.inserted_at)
  end
end
