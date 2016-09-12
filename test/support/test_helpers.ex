defmodule CrambearPhoenix.TestHelpers do
  alias CrambearPhoenix.Repo
  alias CrambearPhoenix.Cardset
  alias Sentinel.Authenticator
  alias Sentinel.Registrator
  alias Sentinel.UserHelper

  def login_user(email, password) do
    {:ok, user} = Authenticator.authenticate_by_email email, password
    permissions = UserHelper.model.permissions(user.role)
    login = Guardian.encode_and_sign(user, :token, permissions)
    {user, elem(login, 1)} #return token
  end

  def insert_cardset(user, attrs \\ %{}) do
    defaults =  %{
      "name" => "Elixir",
    }
    insert_many_item(user, :cardsets, attrs, defaults)
  end

  def insert_user(email \\ "test@test.com", password \\ "tester") do
    Registrator.changeset(%{"email" => email, "password" => password})
                        |> Repo.insert!
  end

  defp insert_item(module, attrs, defaults) do
    attrs = Map.merge(attrs, defaults)
    changeset = apply(module, :changeset, [ struct(module) , attrs])
    Repo.insert!(changeset)
  end

  defp insert_many_item(parent, many, attrs, defaults) do
    attrs = Map.merge(attrs, defaults)
    changeset = Ecto.build_assoc(parent, many, to_atom_params(attrs))
    Repo.insert!(changeset)
  end

  defp to_atom_params(params) do
    Enum.reduce(params, %{}, fn({key, val}, acc) -> Map.put(acc, String.to_existing_atom(key), val) end)
  end
end

