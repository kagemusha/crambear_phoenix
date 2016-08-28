defmodule CrambearPhoenix.User do
  use CrambearPhoenix.Web, :model

  schema "users" do
    field :name, :string
    field  :email,                       :string     # or :username
    field  :role,                        :string
    field  :password,                    :string, virtual: true
    field  :password_confirmation,       :string, virtual: true
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
    |> cast(user_params, @required_registration_fields, @optional_fields)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6, max: 40)
    |> validate_equal(:password, :password_confirmation)
  end

  def changeset(struct, params \\ :empty) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end

  def permissions(_role) do
  end

  def validate_equal(changeset, field1, field2) do
    %{changes: changes} = changeset
    val1 = Map.get(changes, field1)
    val2 = Map.get(changes, field2)

    cond do
      val1 === val2 ->
        changeset
      true ->
        msg = "#{field1} field doesn't equal #{field2} field"
        add_error changeset, field1, msg
    end

  end
end
