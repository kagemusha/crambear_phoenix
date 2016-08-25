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
  @required_registration_fields ~w(email password password_confirmation)
  @optional_fields ~w()

  def registration_changeset(user_struct, user_params \\ :empty) do
    user_struct
    |> cast(user_params, @required_fields, @optional_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, 6)
    |> validate_length(:password_confirmation, 6)
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def permissions(_role) do
  end
end
