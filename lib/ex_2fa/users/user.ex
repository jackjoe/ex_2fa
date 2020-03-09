defmodule Ex2fa.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ex2fa.User

  @email_format ~r/^[A-Za-z0-9._%+-]+[A-Za-z0-9]@[A-Za-z0-9.-]+\.[A-Za-z]{2,63}$/

  @type t() :: %__MODULE__{
          id: integer(),
          email: String.t(),
          firstname: String.t(),
          lastname: String.t(),
          encrypted_password: String.t(),
          password: String.t(),
          password_confirmation: String.t(),
          is_2fa: boolean,
          otp_secret: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  schema "users" do
    field(:email, :string)
    field(:firstname, :string)
    field(:lastname, :string)
    field(:encrypted_password, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:is_2fa, :boolean)
    field(:otp_secret, :string)

    timestamps()
  end

  @doc false
  @spec changeset(User.t(), map()) :: Ecto.Changeset.t()
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation])
    |> validate_confirmation(:password)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, @email_format)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> hash_password()
    |> generate_otp_secret()
  end

  @spec enable_2fa_changeset(User.t()) :: Ecto.Changeset.t()
  def enable_2fa_changeset(%User{} = user) do
    user
    |> change()
    |> put_change(:is_2fa, true)
  end

  @spec hash_password(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, encrypted_password: Argon2.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  defp generate_otp_secret(changeset) do
    secret = :crypto.strong_rand_bytes(10) |> Base.encode32()
    put_change(changeset, :otp_secret, secret)
  end
end
