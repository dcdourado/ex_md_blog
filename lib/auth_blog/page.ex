defmodule AuthBlog.Page do
  @moduledoc """
  Blog page domain functions.
  """

  alias AuthBlog.Posts

  @home_file_path "assets/home.html.eex"
  @posts_per_page 5

  @doc "Renders page posts"
  @spec render_page_posts(page :: non_neg_integer()) :: String.t()
  def render!(page_number) when is_integer(page_number) and page_number > 0 do
    posts_html = render_page_posts(page_number)
    full_html = EEx.eval_file(@home_file_path, posts: posts_html)

    File.write!("assets/home.html", full_html)
    String.slice(@home_file_path, 0, String.length(@home_file_path) - 4)
  end

  defp render_page_posts(page) do
    [limit: @posts_per_page, offset: (page - 1) * @posts_per_page]
    |> Posts.list()
    |> Enum.map_join(&Posts.to_html/1)
  end
end
