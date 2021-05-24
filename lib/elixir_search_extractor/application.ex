defmodule ElixirSearchExtractor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      ElixirSearchExtractor.Repo,
      # Start the Telemetry supervisor
      ElixirSearchExtractorWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirSearchExtractor.PubSub},
      # Start the Endpoint (http/https)
      ElixirSearchExtractorWeb.Endpoint,
      {Oban, oban_config()}
      # Start a worker by calling: ElixirSearchExtractor.Worker.start_link(arg)
      # {ElixirSearchExtractor.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirSearchExtractor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirSearchExtractorWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  # Conditionally disable crontab, queues, or plugins here.
  defp oban_config do
    Application.get_env(:elixir_search_extractor, Oban)
  end
end
