defmodule ElixirSearchExtractor.FileUpload.Queries.KeywordFileQuery do
  import Ecto.Query
  alias ElixirSearchExtractor.FileUpload.KeywordFile

  def user_keyword_files(user) do
    where(KeywordFile, [file], file.user_id == ^user.id)
  end
end
