defmodule ProjectR0719212.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectR0719212.UserContext.User

  schema "animals" do
    field :cat_or_dog, :string
    field :dob, :date
    field :name, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :dob, :cat_or_dog])
    |> validate_required([:name, :dob, :cat_or_dog])
  end

  def create_changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:name, :dob, :cat_or_dog])
    |> validate_required([:name, :dob, :cat_or_dog])
    |> put_assoc(:user, user)
  end
end
