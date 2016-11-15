defmodule CrambearPhoenix do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Start the Ecto repository
      supervisor(CrambearPhoenix.Repo, []),
      supervisor(CrambearPhoenix.Endpoint, []),
    ]

    opts = [strategy: :one_for_one, name: CrambearPhoenix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    CrambearPhoenix.Endpoint.config_change(changed, removed)
    :ok
  end
end
