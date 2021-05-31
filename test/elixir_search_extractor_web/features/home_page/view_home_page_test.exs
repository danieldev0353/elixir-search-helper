defmodule ElixirSearchExtractorWeb.HomePage.ViewHomePageTest do
  use ElixirSearchExtractorWeb.FeatureCase

  feature "view home page", %{session: session} do
    session
    |> register_and_login()
    |> visit(Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))
    |> assert_has(Query.text("Dashboard!"))
  end
end
