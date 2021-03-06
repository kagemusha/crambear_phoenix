import Ecto.Queryable
import Ecto.Query, only: [from: 1, from: 2]
alias CrambearPhoenix.Repo
alias CrambearPhoenix.User
alias CrambearPhoenix.Cardset
alias CrambearPhoenix.Card
alias CrambearPhoenix.Tag

defmodule R do
  def reload! do
    Mix.Task.reenable "compile.elixir"
    Application.stop(Mix.Project.config[:app])
    Mix.Task.run "compile.elixir"
    Application.start(Mix.Project.config[:app], :permanent)
  end
end