defmodule ElixirSearchExtractorWeb.Api.V1.Keywords.ListView do
  use JSONAPI.View, type: "keywords"

  def fields do
    [
      :title,
      :status
    ]
  end
end
