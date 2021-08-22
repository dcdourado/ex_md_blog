defmodule AuthBlog.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:blog_posts, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :title, :string, size: 120, null: false
      add :description, :string, size: 800, null: true
      add :content, :text, null: false

      add :deleted_at, :naive_datetime, null: true
      timestamps()
    end
  end
end
