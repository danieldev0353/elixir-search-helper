defmodule ElixirSearchExtractorWeb.PageControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  import ElixirSearchExtractor.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET /" do
    test "returns status code 200", %{conn: conn, user: user} do
      user_file = insert(:keyword_file, user: user)
      keyword = insert(:keyword, keyword_file: user_file, status: :completed)

      conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
      home_url = get(conn, "/")

      assert html_response(home_url, 200) =~ keyword.title
    end
  end
end
