defmodule Ex2fa.QRCode do
  @spec gen_qr_code(String.t(), String.t()) :: {:ok, String.t()} | {:error, any}
  def gen_qr_code(challenge, dest) do
    filename = random_filename()

    challenge
    |> QRCode.create()
    |> Result.and_then(&QRCode.Svg.save_as(&1, "#{dest}/#{filename}.svg"))
  end

  defp random_filename() do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64() |> binary_part(0, 20)
  end
end
