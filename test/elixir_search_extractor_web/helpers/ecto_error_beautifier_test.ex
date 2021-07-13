defmodule ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifierTest do
  use ExUnit.Case, async: true

  alias ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifier

  describe "beautify_ecto_error/1" do
    test "it beautifies simple errors" do
      res = EctoErrorBeautifier.beautify_ecto_error([name: {"can't be blank", [validation: :required]}])

      assert ["Name can't be blank"] = res
    end

    test "it beautifies errors with variables" do
      res = EctoErrorBeautifier.beautify_ecto_error([
        login: {"should be at most %{count} character(s)", [count: 10]},
        message_body: "should not be blank"
      ])

      assert String.equivalent?(Enum.at(res, 0), "Login should be at most 10 character(s)")
      assert String.equivalent?(Enum.at(res, 1), "Message body should not be blank")
    end
  end
end
