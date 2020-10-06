defmodule ProjectR0719212.ApiKeyContext.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset
  alias ProjectR0719212.UserContext.User

  schema "apikeys" do
    field :key, :string
    field :name, :string
    field :is_writeable, :boolean, default: false

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:key, :name, :is_writeable])
    |> validate_required([:key, :name, :is_writeable])
  end
  
  def create_changeset(api_key, attrs, user) do
    api_key
    |> cast(attrs, [:name, :is_writeable])
    |> validate_required([:name, :is_writeable])
    |> put_assoc(:user, user)
    |> add()
  end 

  defp key_generate() do
    :crypto.strong_rand_bytes(64)
    |> Base.encode64
    |> binary_part(0,64)
  end

  defp add(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{name: name}} ->
        put_change(changeset, :key, key_generate())
          _->
          changeset
    end
  end

end

