defmodule ElixirSearchExtractorWeb.Plugs.SetCurrentApiUserTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true
  use Plug.Test

  import ElixirSearchExtractor.{AccountsFixtures, AccessTokenFixture}
  alias ElixirSearchExtractorWeb.Plugs.SetCurrentApiUser

  describe "init/1" do
    test "returns the options argument passed to the function" do
      assert SetCurrentApiUser.init([]) == []
    end
  end

  describe "call/2" do
    test "assigns logged in api user to conn.assign as current_user", %{conn: conn} do
      user = user_fixture()
      access_token = access_token_fixture(user)

      conn =
        conn
        |> put_req_header("authorization", "Bearer " <> access_token.token)
        |> post(Routes.api_v1_keyword_file_path(conn, :create), %{})

      assert conn.assigns.current_user.id == user.id
    end
  end
end
