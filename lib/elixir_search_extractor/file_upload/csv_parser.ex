defmodule ElixirSearchExtractor.FileUpload.CsvParser do
  import Ecto.Query, warn: false

  alias ElixirSearchExtractor.SearchKeyword.SearchKeywords
  alias NimbleCSV.RFC4180, as: CSV

  def parse(keyword_file) do
    with {:ok, keyword_list} <- extract_keywords(keyword_file.csv_file) do
      Enum.each(keyword_list, fn keyword ->
        SearchKeywords.save_keyword(keyword, keyword_file.id)
      end)
    end

    :ok
  end

  defp extract_keywords(file_path) do
    keyword_list =
      file_path
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.to_list()
      |> List.flatten()

    {:ok, keyword_list}
  end
end
