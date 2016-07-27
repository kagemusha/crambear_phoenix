# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CrambearPhoenix.Repo.insert!(%CrambearPhoenix.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seeds do
  import Ecto.Query, only: [from: 1, from: 2]
  alias CrambearPhoenix.Repo
  alias CrambearPhoenix.Cardset
  alias CrambearPhoenix.Card
  alias CrambearPhoenix.Tag

  def add_cardset(name,  cards) do

    cardset = Repo.insert!(%Cardset{name: name })

    for card_attrs <- cards do
      card_struct = case card_attrs do
         [front, back] -> %Card{ front: front, back: back }
      end

      card = Repo.insert! card_struct
             |> Repo.preload(:cardset)

      card
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:cardset, cardset)
      |> Repo.update!
    end
  end

  def cleanup do
    from(t in Tag) |> Repo.delete_all
    from(c in Card) |> Repo.delete_all
    from(cs in Cardset) |> Repo.delete_all
  end
end

IO.puts "Seeding...."

Seeds.cleanup
  
ember_cards = [
  ["How would you make a computed property dependent on the 'count' attribute on an array pointed to by property 'items?'","Ember.computed('items.@each.count', ...)"],
  ["What Ember function returns true is its argument is null, undefined, or an empty string or array?","Ember.isBlank(obj)"],
  ["What Ember 2.1 HTMLBars helper allows you to iterate over a set of properties?","{{#each-in obj as |key value|}}"],
  ["What's the new preferred way to write Ember.computed(someFunction).property('propA','propB')?", "Ember.computed('propA','propB', someFunction)"],
  ["What is Ember.$?", "An alias for jQuery: Ember.$ = jQuery;"],
  ["What functions do you need to override to create a custom adapter?", "findRecord, createRecord, updateRecord, deleteRecord, findAll, query (and may want to override findMany for optimizations)"],
]
  
                  
Seeds.add_cardset "ember",  ember_cards
