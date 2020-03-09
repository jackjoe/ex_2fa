defmodule Ex2faWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  alias Ex2faWeb.Router.Helpers, as: Routes

  alias Ex2fa.Users

  @moduledoc """
  Plug to enforce authentication. When called by a pipeline, the plug will try to find a truthy `signed_in` boolean on the conn. When present it continues, otherwise the conn is halted and redirected to the login form.

  The Plug also contains methods to provide sign in and sign out. These are typically called from the auth controller.
  """

  @spec init(any) :: any
  def init(opts), do: opts

  @spec call(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def call(conn, _) do
    with user_id when not is_nil(user_id) <- get_session(conn, :current_user_id),
         user when not is_nil(user) <- Users.get_user(user_id) do
      conn
      |> assign(:current_user, user)
      |> assign(:signed_in?, true)
    else
      _ ->
        conn
        |> assign(:current_user, nil)
        |> assign(:signed_in?, false)
        |> redirect(to: Routes.auth_path(conn, :new))
        |> halt()
    end
  end

  @doc """
  Signs in a user resource.
  Puts the user on the conn (`current_user`) and also a boolean to facilitate easy logged in checks.
  """
  @spec sign_in(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
  def sign_in(conn, user) do
    put_session(conn, :current_user_id, user.id)
  end

  @doc "Sign out a user"
  @spec sign_out(Plug.Conn.t()) :: Plug.Conn.t()
  def sign_out(conn) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
  end

  @doc """
  Marks a user resource as 'busy with 2FA'.
  Puts the user on the conn (`current_user`) and also a boolean that he still has to confirm the 2FA process.
  That way, we have the user resource on the conn since we need the user resource to match the TOTP code against, but this plug is only applied to the 2FA index routes. No other pages then that will be accessible without proper auth.
  """
  @spec mark_2fa(Plug.Conn.t(), User.t()) :: Plug.Conn.t()
  def mark_2fa(conn, user) do
    put_session(conn, :two_factor_user_id, user.id)
  end

  def check_two_factor_auth(conn, _) do
    with user_id when not is_nil(user_id) <- get_session(conn, :two_factor_user_id),
         user when not is_nil(user) <- Users.get_user(user_id) do
      assign(conn, :current_user, user)
    else
      e ->
        conn
        |> assign(:current_user, nil)
        |> redirect(to: Routes.auth_path(conn, :new))
    end
  end
end
