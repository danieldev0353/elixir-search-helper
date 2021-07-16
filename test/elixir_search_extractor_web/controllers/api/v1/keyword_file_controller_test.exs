defmodule ElixirSearchExtractorWeb.Api.V1.KeywordFileControllerTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true

  import ElixirSearchExtractor.{AccountsFixtures, AccessTokenFixture, KeywordFileFixtures}

  describe "post api/v1/keyword_files" do
    test "returns 201 status with uploaded file when valid data is given", %{
      conn: conn
    } do
      user = user_fixture()

      conn =
        conn
        |> set_authentication_header(user)
        |> post(Routes.api_v1_keyword_file_path(conn, :create), valid_keyword_file_attributes())

      assert %{
               "data" => %{
                 "attributes" => %{
                   "csv_file" => _,
                   "name" => "Test File",
                   "status" => "pending"
                 },
                 "id" => _,
                 "links" => _,
                 "relationships" => %{},
                 "type" => "keyword_files"
               },
               "included" => [],
               "links" => _
             } = json_response(conn, 201)

      remove_uploaded_files(user.id)
    end

    test "returns 422 status with reason if no CSV file is given", %{conn: conn} do
      conn =
        conn
        |> set_authentication_header()
        |> post(Routes.api_v1_keyword_file_path(conn, :create), %{
          "name" => "Test",
          "csv_file" => nil
        })

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "A CSV file must be uploaded!"}]
             }
    end

    test "returns 422 status with reason if no name of file is given", %{conn: conn} do
      conn =
        conn
        |> set_authentication_header()
        |> post(Routes.api_v1_keyword_file_path(conn, :create), %{
          "name" => nil,
          "csv_file" => valid_csv_file()
        })

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => %{"name" => ["can't be blank"]}}]
             }
    end

    test "returns 422 status with reason if invalid file is given", %{conn: conn} do
      conn =
        conn
        |> set_authentication_header()
        |> post(Routes.api_v1_keyword_file_path(conn, :create), %{
          "name" => nil,
          "csv_file" => invalid_extension_file()
        })

      assert json_response(conn, 422) == %{
               "errors" => [%{"detail" => "File must be a CSV!"}]
             }
    end
  end
end
