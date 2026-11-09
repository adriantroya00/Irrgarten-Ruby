# encoding: UTF-8
require_relative 'Game'
require_relative 'TextUI'
require_relative 'Directions'

game = Irrgarten::Game.new(2, 2)

vista = UI::TextUI.new
vista.show_game(game.game_state)

game.next_step(Irrgarten::Directions::DOWN)
vista.show_game(game.game_state)

game.current_player.health = 0

10.times do
  game.next_step(Irrgarten::Directions::LEFT)
  vista.show_game(game.game_state)
end
