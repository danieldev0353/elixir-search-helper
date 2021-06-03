defmodule ElixirSearchExtractorWeb.SharedViewTest do
  use ElixirSearchExtractorWeb.ConnCase, async: true

  alias ElixirSearchExtractorWeb.SharedView

  describe "abbreviated_name/1" do
    test "returns the abbreviation of the user name" do
      name = "John Doe"

      assert SharedView.abbreviated_name(name) == "J"
    end
  end
end
