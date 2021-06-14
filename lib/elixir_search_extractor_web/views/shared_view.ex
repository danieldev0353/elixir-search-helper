defmodule ElixirSearchExtractorWeb.SharedView do
  use ElixirSearchExtractorWeb, :view

  def abbreviated_name(user_name) do
    user_name
    |> String.at(0)
    |> String.upcase()
  end
end
