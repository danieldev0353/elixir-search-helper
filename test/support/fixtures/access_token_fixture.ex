defmodule ElixirSearchExtractor.AccessTokenFixture do
  import ElixirSearchExtractor.{AccountsFixtures, OauthApplicationFixture}
  alias ExOauth2Provider.AccessTokens

  def access_token_fixture do
    {_, access_token} =
      AccessTokens.create_token(user_fixture(), %{application: oauth_application_fixture()},
        otp_app: :elixir_search_extractor
      )

    access_token
  end

  def access_token_fixture(user) do
    {_, access_token} =
      AccessTokens.create_token(user, %{application: oauth_application_fixture()},
        otp_app: :elixir_search_extractor
      )

    access_token
  end
end
