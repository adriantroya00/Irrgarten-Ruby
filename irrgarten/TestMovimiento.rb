# encoding: UTF-8
require_relative 'Game'
require_relative 'TextUI'
require_relative 'Directions'

game = Irrgarten::Game.new(2, true)
vista = UI::TextUI.new

vista.show_game(game.game_state)

game.labyrinth.send(:put_player_2D,
                    game.current_player.row,
                    game.current_player.col,
                    2, 0,
                    game.current_player)

vista.show_game(game.game_state)

game.next_step(Irrgarten::Directions::UP)   
vista.show_game(game.game_state)
