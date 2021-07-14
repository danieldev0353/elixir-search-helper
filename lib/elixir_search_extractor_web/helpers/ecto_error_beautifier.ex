defmodule ElixirSearchExtractorWeb.Helpers.EctoErrorBeautifier do
  def beautify_ecto_error(changeset) do
    out =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    out
  end
end
