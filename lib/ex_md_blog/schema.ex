defmodule ExMdBlog.Schema do
  @moduledoc """
  Project common schema.
  """

  defmacro __using__(_opts) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      @primary_key {:id, :binary_id, autogenerate: true}
      @foreign_key_type :binary_id
      # redacted fields are appearing
      @derive {Jason.Encoder, except: [:__meta__]}
    end
  end
end
