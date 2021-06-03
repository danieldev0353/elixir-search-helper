defmodule ElixirSearchExtractorWeb.SettingsPage.SettingsPageTest do
  use ElixirSearchExtractorWeb.FeatureCase

  feature "view settings page", %{session: session} do
    session
    |> register_and_login()
    |> visit(Routes.user_settings_path(ElixirSearchExtractorWeb.Endpoint, :edit))
    |> assert_has(Query.text("Change password!"))
  end

  feature "user can change password if correct current password is given", %{session: session} do
    password = "current_password"

    session
    |> register_and_login(password)
    |> change_password(password)
    |> assert_has(Query.text("Password updated successfully."))
  end

  feature "user can not change password if incorrect current password is given", %{session: session} do
    password = "invalid_current_password"

    session
    |> register_and_login()
    |> change_password(password)
    |> assert_has(Query.text("Oops, something went wrong!"))
  end

  defp change_password(session, password) do
    session
    |> visit(Routes.user_settings_path(ElixirSearchExtractorWeb.Endpoint, :edit))
    |> fill_in(Wallaby.Query.text_field("user_password"), with: "new_password")
    |> fill_in(Wallaby.Query.text_field("user_password_confirmation"), with: "new_password")
    |> fill_in(Wallaby.Query.text_field("current_password_for_password"), with: password)
    |> click(Wallaby.Query.button("Change password"))
  end
end
