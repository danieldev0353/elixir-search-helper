defmodule ElixirSearchExtractorWeb.PageController do
  use ElixirSearchExtractorWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
