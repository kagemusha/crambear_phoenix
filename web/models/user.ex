defmodule CrambearPhoenix.User do
  use CrambearPhoenix.Web, :model

  schema "users" do
    field :name, :string
    field  :email,                       :string     # or :username
    field  :role,                        :string
    field  :hashed_password,             :string
    field  :hashed_confirmation_token,   :string
    field  :confirmed_at,                Ecto.DateTime
    field  :hashed_password_reset_token, :string
    field  :unconfirmed_email,           :string
    timestamps
  end

  @required_fields ~w(email)
  @optional_fields ~w()

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def permissions(_role) do
  end
end
