defmodule ElixirSearchExtractorWeb.AuthenticationPage.SignupPageTest do
  use ElixirSearchExtractorWeb.FeatureCase, async: true

  feature "view sign up page", %{session: session} do
    session
    |> visit(Routes.user_registration_path(ElixirSearchExtractorWeb.Endpoint, :new))
    |> assert_has(Query.text("Open an account!"))
  end

  feature "view dashboard after successful sign up", %{session: session} do
    session
    |> signup()
    |> assert_has(Query.text("Keyword Report"))
  end

  defp signup(session) do
    user_attributes = valid_user_attributes()

    session
    |> visit(Routes.user_registration_path(ElixirSearchExtractorWeb.Endpoint, :new))
    |> fill_in(Wallaby.Query.text_field("user_name"), with: user_attributes.name)
    |> fill_in(Wallaby.Query.text_field("user_email"), with: user_attributes.email)
    |> fill_in(Wallaby.Query.text_field("user_password"), with: user_attributes.password)
    |> fill_in(Wallaby.Query.text_field("user_password_confirmation"),
      with: user_attributes.password_confirmation
    )
    |> click(Wallaby.Query.button("Register"))
  end
end
