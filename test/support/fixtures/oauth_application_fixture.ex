defmodule ElixirSearchExtractor.OauthApplicationFixture do
  alias ExOauth2Provider.Applications

  def valid_attributes, do: %{name: "Android App", redirect_uri: "https://google.com/"}

  def oauth_application_fixture do
    {_, oauth_app} =
      Applications.create_application(nil, valid_attributes(), otp_app: :elixir_search_extractor)

    oauth_app
  end
end
