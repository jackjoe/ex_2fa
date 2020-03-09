defmodule Ex2faWeb.TwoFactorAuthController do
  use Ex2faWeb, :controller

  alias Ex2fa.Users
  alias Ex2fa.QRCode
  alias Ex2faWeb.Plugs.Auth

  @qr_path "qrcodes"

  def new(%{assigns: %{current_user: current_user}} = conn, _ \\ %{}) do
    qr_code = gen_qr_code(current_user)
    render(conn, :new, qr_code: qr_code)
  end

  def create(%{assigns: %{current_user: current_user}} = conn, %{"totp_code" => totp_code}) do
    case Users.totp_match?(current_user, totp_code) do
      true ->
        Users.enable_2fa(current_user)
        redirect(conn, to: page_path(conn, :index))

      false ->
        conn
        |> put_flash(:error, gettext("Invalid code"))
        |> new()
    end
  end

  def ask(conn, _ \\ %{}) do
    render(conn, :ask)
  end

  def check(%{assigns: %{current_user: current_user}} = conn, %{"totp_code" => totp_code}) do
    case Users.totp_match?(current_user, totp_code) do
      true ->
        conn
        |> Auth.sign_in(current_user)
        |> redirect(to: page_path(conn, :index))

      false ->
        conn
        |> put_flash(:error, gettext("Invalid code"))
        |> ask()
    end
  end

  # Helpers

  @spec gen_qr_code(User.t()) :: String.t()
  defp gen_qr_code(user) do
    {:ok, qr_code} =
      Users.generate_totp_url(user)
      |> QRCode.gen_qr_code(@qr_path)

    qr_code
  end
end
