defmodule ProjectR0719212.ApiKeyContext do
  @moduledoc """
  The ApiKeyContext context.
  """
  
  import Ecto.Query, warn: false
  alias ProjectR0719212.Repo
  alias ProjectR0719212.UserContext.User
  alias ProjectR0719212.ApiKeyContext.ApiKey
  alias ProjectR0719212.ApiKeyContext
  alias ProjectR0719212.UserContext
  
  
  def load_api_keys(%User{} = u), do: u |> Repo.preload([:apikeys])
  
  @doc """
  Returns the list of apikeys.
  ## Examples
      iex> list_apikeys()
      [%ApiKey{}, ...]
  """
  def list_apikeys do
    Repo.all(ApiKey) 
    |> Repo.preload([:user])
  end



  
  @doc """
  Gets a single api_key.
  Raises Ecto.NoResultsError if the Api key does not exist.
  ## Examples
      iex> get_api_key!(123)
      %ApiKey{}
      iex> get_api_key!(456)
      ** (Ecto.NoResultsError)
  """
  def get_api_key!(id, user), do: Repo.get!(ApiKey, id)
  
  @doc """
  Creates a api_key.
  ## Examples
      iex> create_api_key(%{field: value})
      {:ok, %ApiKey{}}
      iex> create_api_key(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_api_key(attrs, %User{} = user) do
    %ApiKey{}
    |> ApiKey.create_changeset(attrs, user)
    |> Repo.insert()
  end
  
  @doc """
  Updates a api_key.
  ## Examples
      iex> update_api_key(api_key, %{field: new_value})
      {:ok, %ApiKey{}}
      iex> update_api_key(api_key, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_api_key(%ApiKey{} = api_key, attrs) do
    api_key
    |> ApiKey.changeset(attrs)
    |> Repo.update()
  end
  
  @doc """
  Deletes a api_key.
  ## Examples
      iex> delete_api_key(api_key)
      {:ok, %ApiKey{}}
      iex> delete_api_key(api_key)
      {:error, %Ecto.Changeset{}}
  """
  def delete_api_key(%ApiKey{} = api_key, user) do
    if(api_key.user_id == user.id) do
      Repo.delete(api_key)
  
    else
      {:unauthorized}
    end
  end
  @doc """
  Returns an %Ecto.Changeset{} for tracking api_key changes.
  ## Examples
      iex> change_api_key(api_key)
      %Ecto.Changeset{source: %ApiKey{}}
  """
  def change_api_key(%ApiKey{} = api_key) do
    ApiKey.changeset(api_key, %{})
  end
  
  def user_has_given_key?(user_id, key) do
      Repo.exists?(from a in ApiKey, where: ^key == a.key and ^user_id == a.user_id)
  end
  

  def apiKey_canWrite?(user_id,key) do
    Repo.exists?(from k in ApiKey, where: k.key == ^key and k.user_id == ^user_id and k.is_writeable==true)
  end

  def key_mathcing_with_user!(id, user) do
      api = Repo.get!(ApiKey,  id)
      if  user.id == api.user_id do
        {:ok, api}
      else
        {:unauthorized}
      end
    end

    def list_keys do
      Repo.all(ApiKey)
    end
  end