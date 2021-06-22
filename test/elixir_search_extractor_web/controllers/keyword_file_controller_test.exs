defmodule ElixirSearchExtractorWeb.KeywordFileControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  import ElixirSearchExtractor.KeywordsFixtures

  setup :register_and_log_in_user

  describe "index" do
    test "lists all keyword_files", %{conn: conn} do
      conn = get(conn, Routes.keyword_file_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Keyword files"
    end
  end

  describe "new keyword_file" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.keyword_file_path(conn, :new))
      assert html_response(conn, 200) =~ "New Keyword file"
    end
  end

  describe "create keyword_file" do
    test "redirects to index when data is valid", %{conn: conn, user: user} do
      conn =
        post(conn, Routes.keyword_file_path(conn, :create),
          keyword_file: valid_keyword_file_attributes()
        )

      assert redirected_to(conn) == Routes.keyword_file_path(conn, :index)

      index_conn = get(conn, Routes.keyword_file_path(conn, :index))
      assert html_response(index_conn, 200) =~ "Listing Keyword files"

      remove_uploaded_files(user.id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.keyword_file_path(conn, :create),
          keyword_file: valid_keyword_file_attributes(%{"name" => nil, "csv" => nil})
        )

      assert html_response(conn, 200) =~ "New Keyword file"
    end

    test "redirects to new when given file is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.keyword_file_path(conn, :create),
          keyword_file: valid_keyword_file_attributes(%{"csv_file" => invalid_extension_file()})
        )

      assert redirected_to(conn) == Routes.keyword_file_path(conn, :new)
    end
  end
end
