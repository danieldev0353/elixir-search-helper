defmodule ElixirSearchExtractorWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ElixirSearchExtractor.AccountsFixtures
      import ElixirSearchExtractor.Factory

      alias ElixirSearchExtractorWeb.Router.Helpers, as: Routes

      def register_and_login(session) do
        user_attributes = valid_user_attributes()
        user = user_fixture(user_attributes)

        login(session, user_attributes.email, user_attributes.password)
      end

      def login(session, email, password) do
        session
        |> visit(Routes.user_session_path(ElixirSearchExtractorWeb.Endpoint, :new))
        |> fill_in(Wallaby.Query.text_field("user_email"), with: email)
        |> fill_in(Wallaby.Query.text_field("user_password"), with: password)
        |> click(Wallaby.Query.button("Log in"))
      end
    end
  end
end
