defmodule ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifier do
  def beautify_ecto_error(errors), do: Enum.map(errors, &do_prettify/1)

  defp do_prettify({field_name, message}) when is_bitstring(message) do
    human_field_name =
      field_name
      |> Atom.to_string()
      |> String.replace("_", " ")
      |> String.capitalize()

    human_field_name <> " " <> message
  end

  defp do_prettify({field_name, {message, variables}}) do
    compound_message = do_interpolate(message, variables)
    do_prettify({field_name, compound_message})
  end

  defp do_interpolate(string, [{name, value} | rest]) do
    n = Atom.to_string(name)
    msg = String.replace(string, "%{#{n}}", do_to_string(value))
    do_interpolate(msg, rest)
  end

  defp do_interpolate(string, []), do: string

  defp do_to_string(value) when is_integer(value), do: Integer.to_string(value)
  defp do_to_string(value) when is_bitstring(value), do: value
  defp do_to_string(value) when is_atom(value), do: Atom.to_string(value)
end
