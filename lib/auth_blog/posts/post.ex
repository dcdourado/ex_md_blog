defmodule AuthBlog.Posts.Post do
  @moduledoc """
  Post schema.
  """

  use AuthBlog.Schema

  @type t :: %__MODULE__{
          id: Ecto.UUID.t(),
          title: String.t(),
          description: String.t(),
          content: String.t(),
          updated_at: NaiveDateTime.t(),
          inserted_at: NaiveDateTime.t()
        }

  schema "posts" do
    field(:title, :string)
    field(:description, :string)
    field(:content, :string)

    field(:deleted_at, :naive_datetime)
    field(:updated_at, :naive_datetime)
    field(:inserted_at, :naive_datetime)
  end

  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> changeset(params)
    |> validate_required([:title, :content])
  end

  def changeset(%__MODULE__{} = model, params) when is_map(params) do
    model
    |> cast(params, [:title, :description, :content, :deleted_at])
    |> validate_length(:title, min: 1, max: 120)
    |> validate_length(:description, min: 1, max: 800)
    |> validate_length(:content, min: 1)
  end
end
