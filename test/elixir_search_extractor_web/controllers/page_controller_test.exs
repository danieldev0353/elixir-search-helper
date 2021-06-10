defmodule ElixirSearchExtractorWeb.PageControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  import ElixirSearchExtractor.AccountsFixtures

  setup do
    %{user: user_fixture()}
  end

  test "GET /", %{conn: conn, user: user} do
    conn = conn |> log_in_user(user) |> get(Routes.user_session_path(conn, :new))
    home_url = get(conn, "/")
    assert html_response(home_url, 200) =~ "Dashboard!"
  end
end
