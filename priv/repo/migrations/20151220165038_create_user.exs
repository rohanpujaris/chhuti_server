defmodule ChhutiServer.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :picture, :text

      timestamps
    end

  end
end
