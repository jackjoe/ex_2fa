defmodule Ex2faWeb.PageController do
  use Ex2faWeb, :controller

  def index(%{assigns: %{current_user: current_user}} = conn, _) do
    render(conn, :index, user: current_user)
  end
end
