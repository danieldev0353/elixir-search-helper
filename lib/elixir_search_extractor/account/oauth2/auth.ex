defmodule ElixirSearchExtractor.Account.Oauth2.Auth do
  alias ElixirSearchExtractor.Account.Schemas.User
  alias ElixirSearchExtractor.Repo

  def authenticate(email, password) do
    User
    |> Repo.get_by(email: email)
    |> verify_password(password)
  end

  defp verify_password(nil, password) do
    # Prevent timing attack
    User.valid_password?("", password)

    {:error, :no_user_found}
  end

  defp verify_password(user, password) do
    case User.valid_password?(user, password) do
      true -> {:ok, user}
      false -> {:error, :invalid_password}
    end
  end
end
