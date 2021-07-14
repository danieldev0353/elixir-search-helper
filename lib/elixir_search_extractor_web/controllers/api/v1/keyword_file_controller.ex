defmodule ElixirSearchExtractorWeb.Api.V1.KeywordFileController do
  use ElixirSearchExtractorWeb, :controller

  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractorWeb.Api.V1.ErrorView
  alias ElixirSearchExtractorWeb.EctoErrorBeautifierHelper

  def create(conn, keyword_file_params) do
    case FileUploads.create_keyword_file(keyword_file_params, conn.assigns.current_user.id) do
      {:ok, _} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, "Upload Successful")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json",
          errors: [%{detail: EctoErrorBeautifierHelper.beautify_ecto_error(changeset)}]
        )

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ErrorView)
        |> render("error.json", errors: [%{detail: reason}])
    end
  end
end
