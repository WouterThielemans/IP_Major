defmodule ProjectR0719212.Repo.Migrations.CreateApikeys do
  use Ecto.Migration

  def change do
    create table(:apikeys) do
      add :key, :string
      add :name, :string
      add :is_writeable, :boolean
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:apikeys, [:user_id])
  end
end
