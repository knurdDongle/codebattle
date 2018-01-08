defmodule CodebattleWeb.LobbyChannelTest do
    use CodebattleWeb.ChannelCase, async: true
  
    alias CodebattleWeb.LobbyChannel

    setup do
        user1 = insert(:user)
        user2 = insert(:user)
        task = insert(:task)

        user_token1 = Phoenix.Token.sign(socket(), "user_token", user1.id)
        {:ok, socket1} = connect(CodebattleWeb.UserSocket, %{"token" => user_token1})

        user_token2 = Phoenix.Token.sign(socket(), "user_token", user2.id)
        {:ok, socket2} = connect(CodebattleWeb.UserSocket, %{"token" => user_token2})

        {:ok, %{user1: user1, user2: user2, socket1: socket1, socket2: socket2, task: task}}
    end
  
    test "sends game info when user join", %{user1: user1, socket1: socket1, task: task} do
        state = :waiting_opponent
        data = %{players: [%{id: user1.id, user: user1}, %{}], task: task}
        game = setup_game(state, data)
        game_topic = "game:" <> to_string(game.id)

        {:ok, %{games: games}, _socket1} = subscribe_and_join(socket1, LobbyChannel, "lobby")

        assert length(games) == 1
    end
  end
  