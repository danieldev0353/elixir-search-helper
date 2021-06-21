defmodule ElixirSearchExtractorWeb.KeywordFileControllerTest do
  use ElixirSearchExtractorWeb.ConnCase

  alias ElixirSearchExtractor.FileUpload

  @create_attrs %{file_name: "some file_name", name: "some name"}
  @update_attrs %{file_name: "some updated file_name", name: "some updated name"}
  @invalid_attrs %{file_name: nil, name: nil}

  def fixture(:keyword_file) do
    {:ok, keyword_file} = FileUpload.create_keyword_file(@create_attrs)
    keyword_file
  end

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
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.keyword_file_path(conn, :create), keyword_file: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.keyword_file_path(conn, :show, id)

      conn = get(conn, Routes.keyword_file_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Keyword file"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.keyword_file_path(conn, :create), keyword_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Keyword file"
    end
  end

  describe "edit keyword_file" do
    setup [:create_keyword_file]

    test "renders form for editing chosen keyword_file", %{conn: conn, keyword_file: keyword_file} do
      conn = get(conn, Routes.keyword_file_path(conn, :edit, keyword_file))
      assert html_response(conn, 200) =~ "Edit Keyword file"
    end
  end

  describe "update keyword_file" do
    setup [:create_keyword_file]

    test "redirects when data is valid", %{conn: conn, keyword_file: keyword_file} do
      conn = put(conn, Routes.keyword_file_path(conn, :update, keyword_file), keyword_file: @update_attrs)
      assert redirected_to(conn) == Routes.keyword_file_path(conn, :show, keyword_file)

      conn = get(conn, Routes.keyword_file_path(conn, :show, keyword_file))
      assert html_response(conn, 200) =~ "some updated file_name"
    end

    test "renders errors when data is invalid", %{conn: conn, keyword_file: keyword_file} do
      conn = put(conn, Routes.keyword_file_path(conn, :update, keyword_file), keyword_file: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Keyword file"
    end
  end

  describe "delete keyword_file" do
    setup [:create_keyword_file]

    test "deletes chosen keyword_file", %{conn: conn, keyword_file: keyword_file} do
      conn = delete(conn, Routes.keyword_file_path(conn, :delete, keyword_file))
      assert redirected_to(conn) == Routes.keyword_file_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.keyword_file_path(conn, :show, keyword_file))
      end
    end
  end

  defp create_keyword_file(_) do
    keyword_file = fixture(:keyword_file)
    %{keyword_file: keyword_file}
  end
end
