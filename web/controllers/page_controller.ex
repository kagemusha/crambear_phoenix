defmodule CrambearPhoenix.PageController do
  use CrambearPhoenix.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
