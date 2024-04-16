defmodule ExMdBlog.Page do
  @moduledoc """
  Blog page domain functions.
  """

  require Logger
  alias ExMdBlog.Posts

  @home_path "/priv/pages/home.html.eex"
  @posts_per_page 5

  @doc "Renders page posts and writes HTML file on assets folder"
  @spec render(page_number :: non_neg_integer()) :: {:ok, path :: String.t()} | {:error, any()}
  def render(page_number \\ @posts_per_page) when is_integer(page_number) and page_number > 0 do
    home_full_path = Application.app_dir(:ex_md_blog) <> @home_path

    full_html = EEx.eval_file(home_full_path, post_callouts: render_post_callouts())

    # removing .eex of the original path
    output_path = String.slice(home_full_path, 0, String.length(home_full_path) - 4)

    case File.write(output_path, full_html) do
      :ok ->
        Logger.info("HTML file written to #{output_path}")
        {:ok, output_path}

      err ->
        Logger.error("Error writing HTML file: #{inspect(err)}")
        err
    end
  end

  defp render_post_callouts do
    Posts.list()
    |> Stream.map(&Posts.to_callout_html/1)
    |> Enum.join("\n")
  end
end
