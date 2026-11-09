# encoding: UTF-8

require 'io/console'
require_relative 'Directions'

module UI

  class TextUI

    #https://gist.github.com/acook/4190379
    def read_char
      STDIN.echo = false
      STDIN.raw!
    
      input = STDIN.getc.chr
      if input == "\e" 
        input << STDIN.read_nonblock(3) rescue nil
        input << STDIN.read_nonblock(2) rescue nil
      end
    ensure
      STDIN.echo = true
      STDIN.cooked!
    
      return input
    end

    def next_move
      print "Where? "                                   
      got_input = false
      while (!got_input)                                    # cuando recibamos un imput actuamos
        c = read_char                                       # caracter leido
        case c                                              # depende lo que haya sido c actuamos
          when "\e[A"
            puts "UP ARROW"                                 # decimos cual ha sido la dir elegida
            output = Irrgarten::Directions::UP              # la direccion es:
            got_input = true                                # dejamos de comprobar pues hemos obtenido un imput
          when "\e[B"
            puts "DOWN ARROW"
            output = Irrgarten::Directions::DOWN
            got_input = true
          when "\e[C"
            puts "RIGHT ARROW"
            output = Irrgarten::Directions::RIGHT
            got_input = true
          when "\e[D"
            puts "LEFT ARROW"
            output = Irrgarten::Directions::LEFT
            got_input = true
          when "\u0003"
            puts "CONTROL-C"
            got_input = true
            exit(1)
          else
            #Error
        end
      end
      output
    end

    # @author Alvaro Perez Sanchez
    # @author Adrian Hernando Leal
    def show_game(game_state)
      
      puts "=====JUGADORES====="
      puts "#{game_state.get_players()}"
      
      puts "=====MONSTRUOS====="
      puts "#{game_state.get_monsters()}"
      
      puts "=====LOG====="
      puts "#{game_state.get_log()}"
      
      puts "Turno del jugador: #{game_state.get_current_player()}"
      
      puts "=====LABERINTO====="
      puts "#{game_state.get_labyrinth()}"
      
      if game_state.winner?
        puts "Hay un ganador. Fin de la partida"
      end
    end

  end # class   

end # module   


