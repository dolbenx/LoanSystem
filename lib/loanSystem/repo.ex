defmodule LoanSystem.Repo do
  use Ecto.Repo,
    otp_app: :loanSystem,
    # adapter: Ecto.Adapters.Postgres
    adapter: Ecto.Adapters.Tds
end
