defmodule ElixirSearchExtractor.SearchKeywords do
  @moduledoc """
  The SearchKeywords context.
  """

  import Ecto.Query, warn: false
  alias ElixirSearchExtractor.Repo

  alias ElixirSearchExtractor.SearchKeywords.Keyword

  def list_keywords do
    Repo.all(Keyword)
  end

  def create_keyword(attrs \\ %{}) do
    %Keyword{}
    |> Keyword.changeset(attrs)
    |> Repo.insert()
  end

  def update_keyword(%Keyword{} = keyword, attrs) do
    keyword
    |> Keyword.changeset(attrs)
    |> Repo.update()
  end

end
