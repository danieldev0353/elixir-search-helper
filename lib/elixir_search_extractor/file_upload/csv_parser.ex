defmodule ElixirSearchExtractor.FileUpload.CsvParser do
  import Ecto.Query, warn: false
  alias NimbleCSV.RFC4180, as: CSV

  def parse(keyword_file) do
    keyword_list =
      keyword_file.csv_file
      |> File.stream!()
      |> CSV.parse_stream(skip_headers: false)
      |> Enum.to_list()
      |> List.flatten()

    {:ok, keyword_list}
  end
end
