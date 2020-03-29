defmodule Lists.Repo do
  use Ecto.Repo,
    otp_app: :lists,
    adapter: Ecto.Adapters.Postgres
end
