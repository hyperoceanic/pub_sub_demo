defmodule PubSubDemo.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PubSubDemoWeb.Telemetry,
      PubSubDemo.Repo,
      {DNSCluster, query: Application.get_env(:pub_sub_demo, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PubSubDemo.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PubSubDemo.Finch},
      # Start a worker by calling: PubSubDemo.Worker.start_link(arg)
      # {PubSubDemo.Worker, arg},
      # Start to serve requests, typically the last entry
      PubSubDemoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PubSubDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PubSubDemoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
