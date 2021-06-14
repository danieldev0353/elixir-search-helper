defmodule ElixirSearchExtractorWeb.LayoutViewTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true

  alias ElixirSearchExtractorWeb.LayoutView

  describe "body_class_name/1" do
    test "returns the CSS classes for the document body" do
      conn =
        get(build_conn(), Routes.user_registration_path(ElixirSearchExtractorWeb.Endpoint, :new))

      assert LayoutView.body_class_name(conn) == "user-registration new"
    end
  end
end
