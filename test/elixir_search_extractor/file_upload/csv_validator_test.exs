defmodule ElixirSearchExtractor.FileUpload.CsvValidatorTest do
  use ElixirSearchExtractor.DataCase, async: true

  import ElixirSearchExtractor.KeywordFileFixtures
  alias ElixirSearchExtractor.FileUpload.CsvValidator

  describe "validate_file/1" do
    test "returns ok if valid file given" do
      assert :ok = CsvValidator.validate_file(valid_csv_file())
    end

    test "invalid CSV exceeding 1MB in size returns error with reason" do
      assert {:error, reason} = CsvValidator.validate_file(large_csv_file())

      assert reason == "File size must be less than 1MB!"
    end

    test "returns error with reason when no file is given" do
      assert {:error, reason} = CsvValidator.validate_file(nil)

      assert reason == "A CSV file must be uploaded!"
    end

    test "file with invalid extension returns error with reason" do
      assert {:error, reason} = CsvValidator.validate_file(invalid_extension_file())

      assert reason == "File must be a CSV!"
    end
  end
end
