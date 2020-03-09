defmodule Ex2fa.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string, size: 75)
      add(:firstname, :string, size: 75, default: "")
      add(:lastname, :string, size: 75, default: "")
      add(:encrypted_password, :string)
      add(:is_2fa, :boolean, default: false)
      add(:otp_secret, :string)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end
end
