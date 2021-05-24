defmodule ElixirSearchExtractorWeb.HomePage.ViewHomePageTest do
  use ElixirSearchExtractorWeb.FeatureCase

  feature "view home page", %{session: session} do
    visit(session, Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))

    assert_has(session, Query.text("Welcome to Phoenix!"))
  end
end
