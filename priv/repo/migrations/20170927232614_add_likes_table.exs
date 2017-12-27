defmodule Blog.Repo.Migrations.AddLikesTable do
  use Ecto.Migration

  def change do

    create table(:likes) do
      add :user_id, :integer
      add :type, :string
      add :liked_item_id, :integer
      add :meta1, :string
      add :meta2, :string
      timestamps()
    end
  end
end
