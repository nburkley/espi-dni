defmodule EspiDni do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(EspiDni.Endpoint, []),
      # Start the Ecto repository
      supervisor(EspiDni.Repo, []),
      # Start supervisor for all bots
      supervisor(EspiDni.BotSupervisor, []),
      # Here you could define other workers and supervisors as children
      worker(EspiDni.TokenSupervisor, []),
      worker(EspiDni.AnalyticsSupervisor, []),
      # run task to connect exiting team
      worker(EspiDni.TeamSetup, [], restart: :temporary)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EspiDni.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    EspiDni.Endpoint.config_change(changed, removed)
    :ok
  end
end
