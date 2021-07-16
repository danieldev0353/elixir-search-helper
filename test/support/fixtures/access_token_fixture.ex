defmodule ElixirSearchExtractor.AccessTokenFixture do
  import Plug.Conn
  import ElixirSearchExtractor.{AccountsFixtures, OauthApplicationFixture}
  alias ExOauth2Provider.AccessTokens

  def set_authentication_header(conn) do
    {_, access_token} =
      AccessTokens.create_token(user_fixture(), %{application: oauth_application_fixture()},
        otp_app: :elixir_search_extractor
      )

    put_req_header(conn, "authorization", "Bearer " <> access_token.token)
  end

  def set_authentication_header(conn, user) do
    {_, access_token} =
      AccessTokens.create_token(user, %{application: oauth_application_fixture()},
        otp_app: :elixir_search_extractor
      )

    put_req_header(conn, "authorization", "Bearer " <> access_token.token)
  end
end
