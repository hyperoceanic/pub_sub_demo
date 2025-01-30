defmodule PubSubDemo.Repo do
  use Ecto.Repo,
    otp_app: :pub_sub_demo,
    adapter: Ecto.Adapters.Postgres
end
