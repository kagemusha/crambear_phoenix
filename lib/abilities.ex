defimpl Canada.Can, for: CrambearPhoenix.User do
  alias CrambearPhoenix.User
  alias CrambearPhoenix.Cardset

  def can?(%User{ id: user_id }, action, %Cardset{ user_id: user_id })
    when action in [:show, :delete, :update], do: true

  def can?(_user, action, _)
    when action in [:show, :delete, :update], do: false
#  def can?(%User{ id: user_id }, action, %Cardset{ user_id: user_id })
#    when action in [:show, :delete, :update], do: true

  def can?(%User{ id: user_id }, _, _), do: true
end