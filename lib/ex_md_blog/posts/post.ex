defmodule ExMdBlog.Posts.Post do
  @moduledoc """
  Post schema.
  """

  @type t :: %__MODULE__{
          id: String.t(),
          title: String.t(),
          content: String.t() | nil
        }

  defstruct [:id, :title, :content]
end
