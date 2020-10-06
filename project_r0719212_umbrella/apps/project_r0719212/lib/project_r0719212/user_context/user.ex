defmodule ProjectR0719212.UserContext.User do
  use Ecto.Schema

  import Ecto.Changeset
  alias ProjectR0719212.AnimalContext.Animal
  alias ProjectR0719212.ApiKeyContext.ApiKey

  @acceptable_roles ["Admin", "User"]

  schema "users" do
    field :hashed_password, :string
    field :role, :string, default: "User"
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :oldpassword, :string, virtual: true
    field :username, :string
    
    has_many :animals, Animal
    has_many :apikeys, ApiKey

    timestamps()
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  #
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role, :password_confirmation])
    |> validate_required([:username, :password, :role, :password_confirmation])
    |> unique_constraint(:username)
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

  def changeset_no_role(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :password_confirmation])
    |> validate_required([:username, :password, :password_confirmation])
    |> unique_constraint(:username, message: "has already been taken")
    |> validate_confirmation(:password, message: "does not match confirmation")
    |> put_password_hash()
  end

  def changeset_username(user, attrs) do
    user
     |> cast(attrs, [:username])
     |> validate_required([:username])
     |> unique_constraint(:username, message: "has already been taken")
  end

  def changeset_password(user, attrs) do
     user
     |> cast(attrs, [:password])
     |> validate_required([:password])
     |> check_old_password(user, attrs)
     |> validate_confirmation(:password, message: "does not match confirmation")
     |> put_password_hash()
  end

  defp check_old_password(%Ecto.Changeset{} = changeset, user, %{"oldpassword" => oldpassword}) do
    case Pbkdf2.verify_pass(oldpassword, user.hashed_password) do
      true -> changeset
      false -> add_error(changeset, :oldpassword, "old password is not correct")
    end
  end

  defp put_password_hash(changeset), do: changeset

end