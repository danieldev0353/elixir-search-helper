defmodule ElixirSearchExtractor.Factory do
  use ExMachina.Ecto, repo: ElixirSearchExtractor.Repo

  use ElixirSearchExtractor.FileUpload.KeywordFileFactory
end
