defmodule ElixirSearchExtractorWeb.HomePage.ViewHomePageTest do
  use ElixirSearchExtractorWeb.FeatureCase, async: true

  import ElixirSearchExtractor.AccountsFixtures

  feature "view home page", %{session: session} do
    session
    |> register_and_login()
    |> visit(Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))
    |> assert_has(Query.text("Keyword Report"))
  end

  feature "shows the report table if keywords exist", %{session: session} do
    user_attributes = valid_user_attributes()
    user = user_fixture(user_attributes)
    user_file = insert(:keyword_file, user: user)
    insert(:keyword, keyword_file: user_file)

    session
    |> login(user_attributes.email, user_attributes.password)
    |> visit(Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))
    |> assert_has(Query.text("Title"))
    |> assert_has(Query.text("Top ads"))
    |> assert_has(Query.text("Total ads"))
    |> assert_has(Query.text("Results"))
    |> assert_has(Query.text("Links"))
    |> assert_has(Query.text("Status"))
    |> assert_has(Query.text("HTML"))
  end

  feature "shows the filtered keyword table when user search by keyword", %{session: session} do
    user_attributes = valid_user_attributes()
    user = user_fixture(user_attributes)
    user_file = insert(:keyword_file, user: user)

    filterable_keyword =
      insert(:keyword, title: "Macbook", keyword_file: user_file, status: :completed)

    unfiltered_keyword = insert(:keyword, title: "GPS", keyword_file: user_file, status: :completed)

    session
    |> login(user_attributes.email, user_attributes.password)
    |> visit(Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))
    |> fill_in(Wallaby.Query.text_field("name"), with: "Mac")
    |> click(Wallaby.Query.button("Search"))
    |> assert_has(Query.text(filterable_keyword.title))
    |> refute_has(Query.text(unfiltered_keyword.title))
  end

  feature "shows the No keywords uploaded yet! message if keywords does not exist", %{
    session: session
  } do
    session
    |> register_and_login()
    |> visit(Routes.page_path(ElixirSearchExtractorWeb.Endpoint, :index))
    |> assert_has(Query.text("No keywords uploaded yet!"))
  end
end
