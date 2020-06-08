defmodule Lists.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Lists.Repo

  schema "users" do
    field :encrypted_password, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :encrypted_password])
    |> validate_required([:username, :encrypted_password])
    |> unique_constraint(:username)
    |> update_change(:encrypted_password, &hash_password/1)
  end

  def get_by_username(username) when is_nil(username) do
    nil
  end

  def get_by_username(username) do
    Repo.get_by(Lists.Accounts.User, username: username)
  end

  defp hash_password(password) do
    %{password_hash: hash} = Argon2.add_hash(password)
    hash
  end
end
