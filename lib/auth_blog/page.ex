defmodule AuthBlog.Page do
  @moduledoc """
  Blog page domain functions.
  """

  alias AuthBlog.Posts

  @home_file_path "lib/auth_blog/page/home.html.eex"
  @posts_per_page 5

  @doc "Renders page posts and writes HTML file on assets folder"
  @spec render_page_posts(page :: non_neg_integer()) :: String.t()
  def render(page_number) when is_integer(page_number) and page_number > 0 do
    html_posts = render_page_posts(page_number)

    full_html =
      EEx.eval_file(@home_file_path,
        blog_title: "Dioblog",
        blog_description: "software engineering discussions and some other stuff",
        posts: html_posts,
        author: "@dcdourado"
      )

    # removing .eex of the original path
    output_path = String.slice(@home_file_path, 0, String.length(@home_file_path) - 4)

    case File.write(output_path, full_html) do
      :ok -> {:ok, output_path}
      err -> err
    end
  end

  defp render_page_posts(page) do
    [limit: @posts_per_page, offset: (page - 1) * @posts_per_page, order_by: [inserted_at: :desc]]
    |> Posts.list()
    |> Enum.map_join(&Posts.to_html/1)
  end
end
