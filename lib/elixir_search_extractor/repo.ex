defmodule ElixirSearchExtractor.Repo do
  use Ecto.Repo,
    otp_app: :elixir_search_extractor,
    adapter: Ecto.Adapters.Postgres
end
