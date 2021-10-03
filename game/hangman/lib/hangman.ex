defmodule Hangman do

  def new_game() do
    { :ok, pid } = Supervisor.start_child(Hangman.Supervisor, [])
    pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, { :tally })
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, { :make_move, guess })
  end

  def force_lose(game_pid) do
    GenServer.call(game_pid, { :force_lose })
  end

  def initialized(game_pid) do
    GenServer.call(game_pid, { :initialized })
  end
end
