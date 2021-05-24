defmodule ElixirSearchExtractorWeb.FeatureCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.Feature

      import ElixirSearchExtractor.Factory

      alias ElixirSearchExtractorWeb.Router.Helpers, as: Routes
    end
  end
end
