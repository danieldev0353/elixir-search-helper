defmodule ElixirSearchExtractor.Repo do
  use Ecto.Repo,
    otp_app: :elixir_search_extractor,
    adapter: Ecto.Adapters.Postgres

  use Phoenix.Pagination, per_page: 15
end
