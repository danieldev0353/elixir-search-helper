defmodule ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifierTest do
  use ExUnit.Case

  alias ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifier

  describe "beautify_ecto_error/1" do
    test "beautifies simple errors" do
      response =
        EctoErrorBeautifier.beautify_ecto_error(%Ecto.Changeset{
          errors: [
            name: {"can't be blank", [validation: :required]}
          ],
          types: []
        })

      assert response == %{name: ["can't be blank"]}
    end

    test "beautifies errors with variables" do
      response =
        EctoErrorBeautifier.beautify_ecto_error(%Ecto.Changeset{
          errors: [
            password:
              {"should be at least %{count} character(s)",
               [count: 6, validation: :length, kind: :min, type: :string]},
            name:
              {"should be at least %{count} character(s)",
               [count: 5, validation: :length, kind: :min, type: :string]},
            email: {"must have the @ sign and no spaces", [validation: :format]},
            password_confirmation: {"does not match password", [validation: :confirmation]}
          ],
          types: []
        })

      assert response == %{
               email: ["must have the @ sign and no spaces"],
               name: ["should be at least 5 character(s)"],
               password: ["should be at least 6 character(s)"],
               password_confirmation: ["does not match password"]
             }
    end
  end
end
