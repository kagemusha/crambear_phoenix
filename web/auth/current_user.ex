#see http://learningelixir.joekain.com/using-guardian-and-canary-with-phoenix/

defmodule CrambearPhoenix.Plug.CurrentUser do

  def init(opts), do: opts

  def call(conn, _opts) do
   current_user = Guardian.Plug.current_resource(conn)
   Plug.Conn.assign(conn, :current_user, current_user)
  end
end