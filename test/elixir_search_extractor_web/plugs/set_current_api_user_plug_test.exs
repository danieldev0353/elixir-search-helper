defmodule ElixirSearchExtractorWeb.SetCurrentApiUserPlugTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true
  use Plug.Test

  import ElixirSearchExtractor.{AccountsFixtures, AccessTokenFixture}
  alias ElixirSearchExtractorWeb.SetCurrentApiUserPlug

  describe "init/1" do
    test "returns the options argument passed to the function" do
      assert SetCurrentApiUserPlug.init([]) == []
    end
  end

  describe "call/2" do
    test "assigns logged in api user to conn.assign as current_user", %{conn: conn} do
      user = user_fixture()

      conn =
        conn
        |> set_authentication_header(user)
        |> post(Routes.api_v1_keyword_file_path(conn, :create), %{})

      assert conn.assigns.current_user.id == user.id
    end
  end
end
