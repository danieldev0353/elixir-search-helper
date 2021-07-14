defmodule ElixirSearchExtractor.Account.Oauth2.AuthTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.AccountsFixtures
  alias ElixirSearchExtractor.Account.Oauth2.Auth

  describe "authenticate/2" do
    test "authenticates user if valid email and password is given" do
      user_attributes = valid_user_attributes()
      user = user_fixture(user_attributes)

      assert {:ok, authenticated_user} =
               Auth.authenticate(user_attributes.email, user_attributes.password)

      assert authenticated_user == user
    end

    test "returns no_user_found if email is not found" do
      assert {:error, :no_user_found} = Auth.authenticate("test@email.com", "password")
    end

    test "returns invalid_password found if password is not correct" do
      user_attributes = valid_user_attributes()
      user_fixture(user_attributes)

      assert {:error, :invalid_password} =
               Auth.authenticate(user_attributes.email, "invalid_password")
    end
  end
end
