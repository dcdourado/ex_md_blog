defmodule ExMdBlog.Markdown do
  @moduledoc """
  Posts can be written with the help of markdown and are parsed to HTML.
  """

  @doc "Renders markdown strings to HTML"
  @spec render(String.t()) :: String.t()
  def render(content) when is_binary(content) do
    content
    |> String.split("\n")
    |> Enum.map_join(&process_line/1)
    |> enclose_lists()
  end

  defp process_line(line) do
    line
    |> process_line_start()
    |> process_line_tags()
  end

  defp process_line_start("#" <> header), do: enclose_header(header, 1)
  defp process_line_start("- " <> line_item), do: enclose_list_item(line_item)
  defp process_line_start(""), do: ""
  defp process_line_start(regular_line), do: "<p>#{regular_line}</p>"

  defp enclose_header("#" <> header, level), do: enclose_header(header, level + 1)
  defp enclose_header(" " <> header, level), do: "<h#{level}>#{header}</h#{level}>"

  defp enclose_list_item(line_item), do: "<li>#{line_item}</li>"

  defp process_line_tags(line) do
    line
    |> String.replace(~r/\*\*(.*?)\*\*/, "<strong>\\1</strong>")
    |> String.replace(~r/_(.*?)_/, "<em>\\1</em>")
    |> String.replace(~r/!\[(.+?)\]\((.+?)\)/, "<img src=\"\\2\" alt=\"\\1\" />")
    |> String.replace(~r/\[(.+?)\]\((.+?)\)/, "<a href=\"\\2\">\\1</a>")
  end

  defp enclose_lists(content) do
    String.replace(content, ~r/(<li>.*?<\/li>)+/, "<ul>\\0</ul>")
  end
end
