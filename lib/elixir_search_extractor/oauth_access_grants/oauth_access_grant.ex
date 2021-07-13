defmodule ElixirSearchExtractor.OauthAccessGrants.OauthAccessGrant do
  use Ecto.Schema
  use ExOauth2Provider.AccessGrants.AccessGrant, otp_app: :elixir_search_extractor

  schema "oauth_access_grants" do
    access_grant_fields()

    timestamps()
  end
end
