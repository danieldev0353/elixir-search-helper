defmodule ElixirSearchExtractorWeb.Api.V1.KeywordFileController do
  use ElixirSearchExtractorWeb, :controller

  import ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifier

  alias ElixirSearchExtractor.FileUpload.FileUploads
  alias ElixirSearchExtractorWeb.Api.V1.ErrorView

  def create(conn, keyword_file_params) do
    case FileUploads.create_keyword_file(keyword_file_params, conn.assigns.current_user.id) do
      {:ok, _} ->
        conn
        |> put_resp_header("content-type", "application/json")
        |> send_resp(201, "Upload Successful")

      {:error, %Ecto.Changeset{} = changeset} ->
      IO.inspect(changeset.errors)
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json",
          errors: [%{detail: beautify_ecto_error(changeset.errors)}]
        )

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ErrorView, "error.json", errors: [%{detail: reason}])
    end
  end
end
