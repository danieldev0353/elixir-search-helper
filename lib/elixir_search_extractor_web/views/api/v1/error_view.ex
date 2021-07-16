defmodule ElixirSearchExtractorWeb.Api.V1.ErrorView do
  use JSONAPI.View, type: "error"

  alias ElixirSearchExtractorWeb.EctoErrorHelper

  def render("error.json", %{errors: %Ecto.Changeset{} = changeset}) do
    %{errors: [%{detail: EctoErrorHelper.translate_error(changeset)}]}
  end

  def render("error.json", %{errors: reason}) do
    %{errors: [%{detail: reason}]}
  end
end
