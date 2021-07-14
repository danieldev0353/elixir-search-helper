defmodule ElixirSearchExtractorWeb.LayoutView do
  use ElixirSearchExtractorWeb, :view

  def body_class_name(conn) do
    "#{module_class_name(conn)} #{controller_action_name(conn)}"
  end

  defp module_class_name(conn) do
    conn
    |> controller_module
    |> Phoenix.Naming.resource_name("Controller")
    |> String.replace("_", "-")
  end

  defp controller_action_name(conn) do
    conn
    |> action_name()
    |> Atom.to_string()
    |> String.replace("_", "-")
  end
end
