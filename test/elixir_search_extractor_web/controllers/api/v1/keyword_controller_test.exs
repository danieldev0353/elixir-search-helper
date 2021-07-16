defmodule ElixirSearchExtractorWeb.Api.V1.KeywordControllerTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true

  import ElixirSearchExtractor.{AccountsFixtures, AccessTokenFixture}

  describe "get /api/v1/keywords" do
    test "returns status 200 with user keywords", %{conn: conn} do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      _user_keyword = insert(:keyword, title: "GPS", status: :completed, keyword_file: user_file)
      _other_user_keyword = insert(:keyword)

      conn =
        conn
        |> set_authentication_header(user)
        |> get(Routes.api_v1_keyword_path(conn, :index))

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "title" => "GPS",
                     "status" => "completed"
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keywords"
                 }
               ],
               "included" => [],
               "meta" => %{"page" => _, "page_size" => _, "pages" => _, "records" => _}
             } = json_response(conn, 200)
    end

    test "returns status 200 with filtered data if search param is given", %{conn: conn} do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      _user_keyword = insert(:keyword, title: "GPS", status: :completed, keyword_file: user_file)
      _user_second_keyword = insert(:keyword, keyword_file: user_file)

      conn =
        conn
        |> set_authentication_header(user)
        |> get(Routes.api_v1_keyword_path(conn, :index), %{name: "GPS"})

      assert %{
               "data" => [
                 %{
                   "attributes" => %{
                     "title" => "GPS",
                     "status" => "completed"
                   },
                   "id" => _,
                   "relationships" => %{},
                   "type" => "keywords"
                 }
               ],
               "included" => [],
               "meta" => %{"page" => _, "page_size" => _, "pages" => _, "records" => _}
             } = json_response(conn, 200)
    end

    test "returns status 200 with empty data if user has no keywords", %{conn: conn} do
      conn =
        conn
        |> set_authentication_header()
        |> get(Routes.api_v1_keyword_path(conn, :index), %{name: "GPS"})

      assert %{
               "data" => [],
               "included" => [],
               "meta" => %{"page" => _, "page_size" => _, "pages" => _, "records" => _}
             } = json_response(conn, 200)
    end
  end

  describe "get /api/v1/keywords/:id" do
    test "returns the keyword details if user keyword exists", %{conn: conn} do
      user = user_fixture()
      user_file = insert(:keyword_file, user: user)
      user_keyword = insert(:keyword, title: "GPS", status: :completed, keyword_file: user_file)
      _other_user_keyword = insert(:keyword)

      conn =
        conn
        |> set_authentication_header(user)
        |> get(Routes.api_v1_keyword_path(conn, :show, user_keyword.id))

      assert %{
               "data" => %{
                 "attributes" => %{
                   "html" => _,
                   "inserted_at" => _,
                   "result_count" => _,
                   "result_urls" => _,
                   "status" => "completed",
                   "title" => "GPS",
                   "top_ads_count" => _,
                   "top_ads_urls" => _,
                   "total_ads_count" => _,
                   "total_links_count" => _
                 },
                 "id" => _,
                 "links" => _,
                 "relationships" => %{},
                 "type" => "keyword"
               },
               "included" => [],
               "links" => _
             } = json_response(conn, 200)
    end

    test "returns error message 'Keyword not found!' if user keyword does not exist", %{conn: conn} do
      conn =
        conn
        |> set_authentication_header()
        |> get(Routes.api_v1_keyword_path(conn, :show, 1))

      assert json_response(conn, 404) == %{
               "errors" => [%{"detail" => "Keyword not found!"}]
             }
    end
  end
end
