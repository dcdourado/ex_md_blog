defmodule ExMdBlog.Page do
  @moduledoc """
  Blog page domain functions.
  """

  alias ExMdBlog.Posts

  @home_file_path "lib/ex_md_blog/page/home.html.eex"
  @posts_per_page 5

  @doc "Renders page posts and writes HTML file on assets folder"
  @spec render(page_number :: non_neg_integer()) :: String.t()
  def render(page_number \\ @posts_per_page) when is_integer(page_number) and page_number > 0 do
    full_html =
      EEx.eval_file(@home_file_path,
        blog_title: "dcdourado.me",
        blog_description: "My journey learnings and thoughts as a software engineer",
        post_callouts: render_post_callouts(),
        author: "dcdourado",
        linkedin: "https://linkedin.com/in/dcdourado",
        github: "https://github.com/dcdourado"
      )

    # removing .eex of the original path
    output_path = String.slice(@home_file_path, 0, String.length(@home_file_path) - 4)

    case File.write(output_path, full_html) do
      :ok -> {:ok, output_path}
      err -> err
    end
  end

  defp render_post_callouts do
    Posts.list()
    |> Stream.map(&Posts.to_callout_html/1)
    |> Enum.join("\n")
  end
end
