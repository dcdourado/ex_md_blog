defmodule ExMdBlog.Repo.GoogleDriveRepoAdapter do
  @moduledoc """
  Google Drive repository adapter.
  """

  require Logger

  alias ExMdBlog.Posts.Post
  alias GoogleApi.Drive.V3.Api.Files
  alias GoogleApi.Drive.V3.Connection

  @behaviour ExMdBlog.Repo

  @drive_scope "https://www.googleapis.com/auth/drive.readonly"
  @docs_mimetype "application/vnd.google-apps.document"
  @published_post_prefix "[POST] "

  @impl true
  def all do
    {:ok, conn} = get_conn()
    {:ok, %{files: files}} = Files.drive_files_list(conn)

    files
    |> Stream.filter(&published_post_type?/1)
    |> Enum.map(&build_post/1)
  end

  defp published_post_type?(file) do
    file.mimeType == @docs_mimetype && String.starts_with?(file.name, @published_post_prefix)
  end

  defp build_post(file) do
    %Post{id: file.id, title: String.replace_prefix(file.name, @published_post_prefix, "")}
  end

  @impl true
  def fetch(id) do
    with {:ok, conn} <- get_conn(),
         {:ok, %{body: html}} <-
           Files.drive_files_export(conn, id, "text/html", alt: "media") do
      [_, body_content] = Regex.run(~r/<body[^>]*>(.*?)<\/body>/s, html)

      {:ok, body_content}
    else
      {:error, reason} ->
        Logger.error("Failed to fetch file #{id} because #{inspect(reason)}")
        {:error, reason}
    end
  end

  defp get_conn do
    case Goth.Token.for_scope(@drive_scope) do
      {:ok, %{token: token}} -> {:ok, Connection.new(token)}
      err -> err
    end
  end
end
