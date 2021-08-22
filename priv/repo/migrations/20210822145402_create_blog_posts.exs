defmodule AuthBlog.Repo.Migrations.CreateBlogPosts do
  use Ecto.Migration

  def change do
    create_if_not_exists table(:blog_posts) do
      add :title, :string, size: 120
      add :description, :string, size: 800
      add :content, :text

      add :deleted_at, :naive_datetime
      timestamps()
    end
  end
end
