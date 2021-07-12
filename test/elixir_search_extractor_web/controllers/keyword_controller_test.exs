defmodule ElixirSearchExtractorWeb.KeywordControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  import ElixirSearchExtractor.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  describe "GET html_view/2" do
    test "returns 200 status code if keyword exists", %{conn: conn, user: user} do
      user_file = insert(:keyword_file, user: user)
      keyword = insert(:keyword, keyword_file: user_file, status: :completed, html: "Result View")

      conn = conn |> log_in_user(user) |> get(Routes.keyword_path(conn, :html_view, keyword.id))

      assert html_response(conn, 200) =~ "Result View"
    end

    test "renders 404 error page if the keyword does not exist", %{conn: conn, user: user} do
      assert_error_sent(404, fn ->
        conn
        |> log_in_user(user)
        |> get(Routes.keyword_path(conn, :html_view, 2))
      end)
    end
  end
end
