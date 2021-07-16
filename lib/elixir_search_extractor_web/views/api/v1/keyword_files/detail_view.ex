defmodule ElixirSearchExtractorWeb.Api.V1.KeywordFiles.DetailView do
  use JSONAPI.View, type: "keyword_files"

  def fields do
    [:name, :csv_file, :status]
  end
end
