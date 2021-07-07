defmodule ElixirSearchExtractor.Factory do
  use ExMachina.Ecto, repo: ElixirSearchExtractor.Repo

  use ElixirSearchExtractor.FileUpload.KeywordFileFactory
  use ElixirSearchExtractor.SearchKeyword.KeywordFactory
end
