defmodule ElixirSearchExtractor.Repo.Migrations.CreateKeywordFiles do
  use Ecto.Migration

  def change do
    create table(:keyword_files) do
      add(:name, :string, null: false)
      add(:csv_file, :text, null: false)
      add(:status, :integer, default: 0, null: false)
      add(:user_id, references(:users, on_delete: :nothing))

      timestamps()
    end
  end
end
