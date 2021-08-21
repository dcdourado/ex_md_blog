defmodule AuthBlog.WebServer.Controller do
  @moduledoc """
  Controller.
  """

  def posts_index(_req, _params) do
    [
      %{
        id: 1,
        title: "First post",
        description: "A mocked post for testing the dynamic REST handler.",
        content: """
        # The content

        The plan is:
          - render the content parsing markdown to HTML
          - use post title as route path
        """
      }
    ]
  end
end
