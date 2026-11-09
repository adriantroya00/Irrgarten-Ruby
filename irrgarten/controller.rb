# encoding: UTF-8
# @author Alvaro Perez Sanchez 
# @author Adrian Hernando Leal
module Control
  

  class Controller

    #Iniciador de Controller, se hace new.Controller()
    def initialize(game,view)
      @game = game
      @view = view
    end

    #Funcion de jugar
    def play
      end_of_game = false                           # iniciamos un boolean falso pq el juego no ha terminado
      while (!end_of_game)
        @view.show_game(@game.game_state) 
        direction = @view.next_move 
        end_of_game = @game.next_step(direction)
      end                                           # mientras que el juego siga sin terminar mostramos el juego, hacemos una
                                                    # direccion nueva pedida a view y comprobamos q la direccion cree o no el final del juego 
      @view.show_game(@game.game_state)             # gamestate final de fin de juego
    end
  end # class   
end # module        