# encoding: UTF-8

module Control
  # @author Alvaro Perez Sanchez 
  # @author Adrian Hernando Leal

  class Controller
    def initialize(game,view)
      @game = game
      @view = view
    end

    def play
      end_of_game = false
      while (!end_of_game)
        @view.show_game(@game.game_state) 
        direction = @view.next_move 
        end_of_game = @game.next_step(direction)
      end
      @view.show_game(@game.game_state)
    end
  end # class   
end # module        