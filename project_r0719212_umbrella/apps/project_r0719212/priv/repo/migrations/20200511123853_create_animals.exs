defmodule ProjectR0719212.Repo.Migrations.CreateAnimals do
  use Ecto.Migration

  def change do
    create table(:animals) do
      add :name, :string
      add :dob, :date
      add :cat_or_dog, :string
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:animals, [:user_id])
  end
end
