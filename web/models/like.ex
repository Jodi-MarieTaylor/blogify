defmodule Blog.Like do
  use Blog.Web, :model



  schema "likes" do
    field :liked_item_id, :integer
    field :user_id, :integer
    field :type, :string
    field :meta1, :string
    field :meta2, :string

    timestamps()
  end
  @optional_fields [:liked_item_id, :user_id, :type, :meta1, :meta2]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, Map.keys(params))
    |> validate_required([:liked_item_id, :user_id])
  end
end

alias Blog.Like
