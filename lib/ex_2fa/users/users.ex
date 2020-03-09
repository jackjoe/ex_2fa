defmodule Ex2fa.Users do
  import Ecto.Query, warn: false

  alias Ex2fa.User
  alias Ex2fa.Repo

  @spec get_user!(integer | String.t()) :: User.t() | no_return()
  def get_user!(id), do: get_user_q(id) |> Repo.one!()

  @spec get_user(integer | String.t()) :: User.t() | nil
  def get_user(id), do: get_user_q(id) |> Repo.one()

  defp get_user_q(id) do
    from(u in User, where: u.id == ^id)
  end

  @spec authenticate(String.t(), String.t()) :: any
  def authenticate(email, password) do
    from(
      u in User,
      where: u.email == ^email
    )
    |> Repo.one()
    |> case do
      nil -> {:error, :unknown_user}
      user -> Argon2.check_pass(user, password)
    end
  end

  @spec get_user_by_email(String.t()) :: User.t() | nil
  def get_user_by_email(email) do
    from(
      u in User,
      where: u.email == ^email
    )
    |> Repo.one()
  end

  @spec enable_2fa(User.t()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def enable_2fa(user) do
    User.enable_2fa_changeset(user)
    |> Repo.update()
  end

  @spec generate_totp_code(User.t()) :: String.t()
  def generate_totp_code(%User{otp_secret: secret}) do
    :pot.totp(secret)
  end

  @spec generate_totp_url(User.t()) :: String.t()
  def generate_totp_url(%User{email: email, otp_secret: secret}) do
    "otpauth://totp/TOTP%20Example:#{email}?secret=#{secret}&issuer=TOTP%20Example&algorithm=SHA1&digits=6&period=30"
  end

  @spec totp_match?(User.t(), String.t()) :: boolean
  def totp_match?(user, totp_code) do
    generate_totp_code(user) == totp_code
  end
end
