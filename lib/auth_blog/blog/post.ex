defmodule AuthBlog.Blog.Post do
  @moduledoc """
  Post schema.
  """

  use AuthBlog.Schema

  alias Ecto.{Changeset, UUID}

  @type t :: %__MODULE__{
          id: UUID.t(),
          title: String.t(),
          description: String.t(),
          content: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          deleted_at: NaiveDateTime.t() | nil
        }

  schema "blog_posts" do
    field(:title, :string)
    field(:description, :string)
    field(:content, :string)

    field(:deleted_at, :naive_datetime)
    timestamps()
  end

  @doc "General usage changeset for `${__MODULE__}`"
  @spec changeset(params :: map()) :: Changeset.t()
  def changeset(params) when is_map(params) do
    %__MODULE__{}
    |> changeset(params)
    |> validate_required([:title, :content])
  end

  @spec changeset(model :: __MODULE__.t(), params :: map()) :: Changeset.t()
  def changeset(%__MODULE__{} = model, params) when is_map(params) do
    model
    |> cast(params, [:title, :description, :content, :deleted_at])
    |> validate_deleted()
    |> validate_length(:title, min: 1, max: 120)
    |> validate_length(:description, min: 1, max: 800)
    |> validate_length(:content, min: 1)
  end

  defp validate_deleted(%Changeset{data: %{deleted_at: %NaiveDateTime{}}} = changeset) do
    add_error(changeset, :deleted_at, "can't update a deleted post")
  end

  defp validate_deleted(changeset) do
    changeset
  end
end
