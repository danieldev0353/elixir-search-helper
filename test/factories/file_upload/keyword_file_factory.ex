defmodule ElixirSearchExtractor.FileUpload.KeywordFileFactory do
  defmacro __using__(_opts) do
    quote do
      def keyword_file_factory do
        %ElixirSearchExtractor.FileUpload.Schemas.KeywordFile{
          name: "Test",
          csv_file: "test/support/fixtures/csv_files/valid_keywords.csv",
          status: :pending
        }
      end
    end
  end
end
