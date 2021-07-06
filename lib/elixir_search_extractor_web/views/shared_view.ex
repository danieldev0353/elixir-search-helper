defmodule ElixirSearchExtractorWeb.SharedView do
  use ElixirSearchExtractorWeb, :view

  import Phoenix.Pagination.HTML

  def abbreviated_name(user_name) do
    user_name
    |> String.at(0)
    |> String.upcase()
  end
end
