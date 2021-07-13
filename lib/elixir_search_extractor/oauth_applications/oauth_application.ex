defmodule ElixirSearchExtractor.OauthApplications.OauthApplication do
  use Ecto.Schema
  use ExOauth2Provider.Applications.Application, otp_app: :elixir_search_extractor

  schema "oauth_applications" do
    application_fields()

    timestamps()
  end
end
