defmodule ElixirSearchExtractorWeb.Api.V1.KeywordFileController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractorWeb.Api.V1.ErrorView
  alias ElixirSearchExtractorWeb.Api.V1.KeywordFiles.DetailView

  def create(conn, keyword_file_params) do
    case FileUploads.create_keyword_file(keyword_file_params, conn.assigns.current_user.id) do
      {:ok, keyword_file} ->
        conn
        |> put_status(:created)
        |> put_view(DetailView)
        |> render("show.json", data: keyword_file)

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json", errors: changeset)

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json", errors: reason)
    end
  end
end
