defmodule Ex2fa.Repo do
  use Ecto.Repo,
    otp_app: :ex_2fa,
    adapter: Ecto.Adapters.MyXQL
end
