defmodule Ex2fa.Seeder do
  @moduledoc """
  Seeder to bootstrap the app.

  Provides:
  - users
  """

  alias Ex2fa.Repo
  alias Ex2fa.User

  @users [
    %User{
      email: "randy@geologists.com",
      firstname: "Randy",
      lastname: "Raggedy",
      password: "dummy",
      password_confirmation: "dummy",
      encrypted_password: Argon2.hash_pwd_salt("dummy")
    }
  ]

  def run do
    _ =
      @users
      |> Enum.map(&insert_if_new(&1))
      |> Enum.filter(fn x -> !is_nil(x) end)
  end

  defp exists(%User{} = user), do: Repo.get_by(User, email: user.email)

  defp insert_if_new(%User{} = user) do
    if !exists(user) do
      User.changeset(user, %{})
      |> Repo.insert!()
    end
  end
end
