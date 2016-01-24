defmodule ChhutiServer.Repo.Migrations.AddRoleIdToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role_id, :integer
    end
    create index(:users, [:role_id])
  end
end
