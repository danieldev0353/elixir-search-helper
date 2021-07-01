defmodule ElixirSearchExtractorWeb.KeywordFileController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractor.FileUpload.Schemas.KeywordFile

  def index(conn, params) do
    {keyword_files, pagination} =
      FileUploads.paginated_user_keyword_files(conn.assigns.current_user, params)

    render(conn, "index.html", keyword_files: keyword_files, pagination: pagination)
  end

  def new(conn, _params) do
    changeset = FileUploads.change_keyword_file(%KeywordFile{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"keyword_file" => keyword_file_params}) do
    case FileUploads.create_keyword_file(keyword_file_params, conn.assigns.current_user.id) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Uploaded successfully.")
        |> redirect(to: Routes.keyword_file_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.keyword_file_path(conn, :new))
    end
  end
end
