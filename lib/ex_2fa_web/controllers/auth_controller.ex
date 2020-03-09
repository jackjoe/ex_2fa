defmodule Ex2faWeb.AuthController do
  use Ex2faWeb, :controller
  import Ex2faWeb.Gettext

  alias Ex2fa.Users
  alias Ex2faWeb.Plugs.Auth

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Users.authenticate(email, password) do
      {:ok, %{is_2fa: true} = user} ->
        Auth.mark_2fa(conn, user) |> redirect(to: two_factor_auth_path(conn, :ask))

      {:ok, %{is_2fa: false} = user} ->
        Auth.sign_in(conn, user) |> redirect(to: page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, gettext("Invalid user name or password"))
        |> render(:new)
    end
  end

  def logout(conn, _) do
    conn
    |> Auth.sign_out()
    |> put_flash(:info, gettext("Signed out"))
    |> redirect(to: page_path(conn, :index))
  end
end
