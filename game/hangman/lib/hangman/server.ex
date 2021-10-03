defmodule Hangman.Server do

  alias Hangman.Game
  use   GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    { :ok, Game.new_game() }
  end

  def handle_call({ :make_move, guess }, _from, game) do
    { game, tally } = Game.make_move(game, guess)
    { :reply, tally, game }
  end

  def handle_call({ :tally }, _from, game) do
    { :reply, Game.tally(game), game }
  end

  def handle_call({ :force_lose }, _from, game) do
    { game, _ } = Game.force_lose(game)
    { :reply, Game.tally(game), game }
  end

  def handle_call({ :initialized }, _from, game) do
    { game, _ } = Game.initialized(game)
    { :reply, Game.tally(game), game }
  end
end
