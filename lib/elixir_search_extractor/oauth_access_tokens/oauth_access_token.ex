defmodule ElixirSearchExtractor.OauthAccessTokens.OauthAccessToken do
  use Ecto.Schema
  use ExOauth2Provider.AccessTokens.AccessToken, otp_app: :elixir_search_extractor

  schema "oauth_access_tokens" do
    access_token_fields()

    timestamps()
  end
end
