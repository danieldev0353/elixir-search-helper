defmodule ElixirSearchExtractor.Repo.Migrations.CreateKeywords do
  use Ecto.Migration

  def change do
    create table(:keywords) do
      add :title, :string, null: false
      add :top_ads_count, :integer, null: false, default: 0
      add :top_ads_urls, {:array, :string}, default: []
      add :total_ads_count, :integer, null: false, default: 0
      add :result_count, :integer, null: false, default: 0
      add :result_urls, {:array, :string}, null: false, default: []
      add :total_links_count, :integer, null: false, default: 0
      add :html, :text
      add :status, :integer, null: false, default: 0
      add :keyword_file_id, references(:keyword_files, on_delete: :nothing)

      timestamps()
    end

    create index(:keywords, [:keyword_file_id])
  end
end
