defmodule ElixirSearchExtractorWeb.KeywordPage.ViewHtmlViewPageTest do
  use ElixirSearchExtractorWeb.FeatureCase, async: true

  import ElixirSearchExtractor.AccountsFixtures

  feature "views keyword html if keyword has html response", %{session: session} do
    user_attributes = valid_user_attributes()
    user = user_fixture(user_attributes)
    user_file = insert(:keyword_file, user: user)
    keyword = insert(:keyword, keyword_file: user_file, status: :completed, html: "Result View")

    session
    |> login(user_attributes.email, user_attributes.password)
    |> visit(Routes.keyword_path(ElixirSearchExtractorWeb.Endpoint, :html_view, keyword.id))
    |> focus_frame(Query.css(".html-view"))
    |> assert_has(Query.text("Result View"))
  end

  feature "views No HTML view yet message if keyword status in processing", %{session: session} do
    user_attributes = valid_user_attributes()
    user = user_fixture(user_attributes)
    user_file = insert(:keyword_file, user: user)
    keyword = insert(:keyword, keyword_file: user_file, status: :processing)

    session
    |> login(user_attributes.email, user_attributes.password)
    |> visit(Routes.keyword_path(ElixirSearchExtractorWeb.Endpoint, :html_view, keyword.id))
    |> assert_has(Query.text("No HTML view yet!"))
  end
end
