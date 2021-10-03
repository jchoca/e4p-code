defmodule SocketGallows.Web.HangmanChannel do

  use Phoenix.Channel

  require Logger

  def join("hangman:game", _, socket) do
    socket = socket |> assign(:game, Hangman.new_game())
    Process.send_after(self(), {:tick, 60}, 1000)
    {:ok, socket }
  end

  def handle_in("tally", _, socket) do
    tally = socket.assigns.game |> Hangman.tally()
    push(socket, "tally", tally)
    { :noreply, socket }
  end

  def handle_in("make_move", guess, socket) do
    tally = socket.assigns.game |> Hangman.make_move(guess)
    push(socket, "tally", tally)
    { :noreply, socket }
  end

  def handle_in("new_game", _, socket) do
    socket = socket |> assign(:game, Hangman.new_game())
    handle_in("tally", nil, socket)
  end

  def handle_info({:tick, seconds_left}, socket) do
    handle_seconds(seconds_left, socket)
    { :noreply, socket }
  end

  defp handle_seconds(seconds_left, socket) when seconds_left == 0 do
    push(socket, "seconds_left", %{ seconds_left: 0 })
    tally = socket.assigns.game |> Hangman.force_lose()
    IO.inspect(tally)
    push(socket, "tally", tally)
  end

  defp handle_seconds(seconds_left, socket) do
    push(socket, "seconds_left", %{ seconds_left: seconds_left })
    Process.send_after(self(), {:tick, seconds_left-1}, 1000)
  end
end
