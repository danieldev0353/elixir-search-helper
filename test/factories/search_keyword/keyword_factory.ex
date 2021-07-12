defmodule ElixirSearchExtractor.SearchKeyword.KeywordFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_factory do
        %ElixirSearchExtractor.SearchKeyword.Schemas.Keyword{
          title: "Test",
          status: :processing,
          keyword_file: insert(:keyword_file)
        }
      end
    end
  end
end
