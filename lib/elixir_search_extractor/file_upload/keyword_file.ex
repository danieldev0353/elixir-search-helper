defmodule ElixirSearchExtractor.FileUpload.KeywordFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "keyword_files" do
    field :csv_file, :string
    field :name, :string
    field :status, Ecto.Enum, values: [pending: 0, initialized: 1, failed: 2, completed: 3]

    belongs_to :user, User

    timestamps()
  end

  def changeset(keyword_file, attrs) do
    keyword_file
    |> cast(attrs, [:name, :csv_file, :user_id])
    |> validate_required([:name, :csv_file, :user_id])
  end
end
