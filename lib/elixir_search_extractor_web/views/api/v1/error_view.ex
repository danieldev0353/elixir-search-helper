defmodule ElixirSearchExtractorWeb.Api.V1.ErrorView do
  use JSONAPI.View, type: "error"

  def render("error.json", %{errors: detail}) do
    %{errors: detail}
  end
end
