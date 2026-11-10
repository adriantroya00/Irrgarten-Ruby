# encoding: UTF-8

module Irrgarten
  # @author Alvaro Perez Sanchez
  # @author Adrian Hernando Leal
  require_relative 'Dice'
  require_relative 'Directions'
  require_relative 'Orientation'

  class Labyrinth
    BLOCK_CHAR    = 'X' # obstaculo
    EMPTY_CHAR    = '-' # vacio
    MONSTER_CHAR  = 'M' # monstruo
    COMBAT_CHAR   = 'C' #tiene a la vez monstruo y jugador
    EXIT_CHAR     = 'E' # salida
    ROW = 0             # en un pos[], la posicion 0 es la fila
    COL = 1             #                          1 es la columna

    def initialize(n_rows, n_cols, exit_row, exit_col)
      @n_rows = n_rows        # numero de filas
      @n_cols = n_cols        # numero de columnas
      @exit_row = exit_row    # fila de salida
      @exit_col = exit_col    # columna de salida

      @labyrinth = Array.new(@n_rows){ Array.new(@n_cols, EMPTY_CHAR)}  # laberinto que empieza vacio
      @monsters = Array.new(@n_rows){ Array.new(@n_cols)}               # array de monstruos
      @players = Array.new(@n_rows){ Array.new(@n_cols)}                # array de jugadores

      @labyrinth[exit_row][exit_col] = EXIT_CHAR                        # añadimos al laberinto la casilla de salida
    end

    def spread_players(players)
      players.each do |p|                                 # para cada jugador
        pos = random_empty_pos                            # creamos una posicion vacia
        put_player_2D(-1, -1, pos[ROW], pos[COL], p)      # colocamos los jugadores que antes no tenian posicion, en la nueva
      end
    end

    def have_a_winner
      @players[@exit_row][@exit_col] != nil               # si hay un jugador en la casilla de salida
    end

    def to_s
      s = " Laberinto {\n"
      for i in 0...@n_rows
        for j in 0...@n_cols
          s += @labyrinth[i][j]
        end
        s += "\n"
      end
      s + "}\n"
    end

    def add_monster(row, col, monster)          
      if pos_ok(row, col) && empty_pos(row,col)         # si la posicion esta dentro de los limites y esta vacia
        @labyrinth[row][col] = MONSTER_CHAR             # colocamos el monstruo en el laberinto
        @monsters[row][col] = monster                   # colocamos el monstruo en el array de monstruos
        monster.set_pos(row, col)                       # le damos al monstruo su fila y columna
      end
    end

    def put_player(direction, player)
      # posicion actual del jugador
      old_row = player.row
      old_col = player.col

      
      new_pos = dir_2_pos(old_row, old_col, direction)                                  # se calcula la nueva direccion
      monster = put_player_2D(old_row, old_col, new_pos[ROW], new_pos[COL], player)     # ponemos el jugador en la nueva direccion y obtenemos el monstruo q haya en esa posicion
      
      monster   # devolvemos el monstruo q habra en esa posicion, si no hay devolvera nil
    end

    def add_block(orientation, start_row, start_col, length)    # dibuja una linea de obstaculos
      if orientation == Orientation::VERTICAL                   # si vamos a hacerlo en vertical nos moveremos en las filas
        inc_row = 1
        inc_col = 0
      else                                                      # si vamos a hacerlo en horizontal nos moveremos en las columnas
        inc_row = 0
        inc_col = 1
      end
      row = start_row                                           
      col = start_col

      while pos_ok(row, col) && (empty_pos(row, col) && (length > 0)) # mientras que la casilla de inicio sea correcta y vacia, y la longitud del bloque sea mayor q 0
        @labyrinth[row][col] = BLOCK_CHAR                             # colocamos el bloque

        length -= 1                                                   # disminuimos el tamaño restante del bloque
        row += inc_row                                                # nos movemos en la direccion necesaria
        col += inc_col
      end
    end

    def valid_moves(row, col)             # devuelve un array con las los movimientos validos desde una posicion, player_move usara la primera si la pedida no es valida
      output = Array.new()  

      if can_step_on(row +1, col)
        output << Directions::DOWN
      end

      if can_step_on(row -1, col)
        output << Directions::UP
      end

      if can_step_on(row, col +1)
        output << Directions::RIGHT
      end

      if can_step_on(row, col -1)
        output << Directions::LEFT
      end

      output
    end

    #Cambiamos la visibilidad de esta funcion ya que la nececita Game para poder colocar monstruos en posiciones vacias
    def random_empty_pos
      begin                               # creamos posicion random hasta que sea vacia
        row = Dice.random_pos(@n_rows)  
        col = Dice.random_pos(@n_cols)
      end until empty_pos(row, col)

      [row, col]
    end

    private

    def pos_ok(row, col)
      0 <= row && row < @n_rows &&
      0 <= col && col < @n_cols
    end

    def empty_pos(row, col)
      @labyrinth[row][col] == EMPTY_CHAR
    end
    
    def monster_pos(row, col)
      @labyrinth[row][col] == MONSTER_CHAR
    end

    def exit_pos(row, col)
      @labyrinth[row][col] == EXIT_CHAR
    end

    def combat_pos(row, col)
      @labyrinth[row][col] == COMBAT_CHAR
    end

    def can_step_on(row, col)           # si es una posicion valida y, hay monstruo, salida, o vacia
      pos_ok(row, col) &&
      (monster_pos(row, col) ||
      exit_pos(row, col) ||
      empty_pos(row, col))
    end

    def update_old_pos(row, col)
      if pos_ok(row, col)                         # si la posicion esta en el tablero
        if combat_pos(row, col)                   # si habia un combate
          @labyrinth[row][col] = MONSTER_CHAR     # pasa a indicar que hay un monstruo
        else                                      # si solo estaba el jugador
          @labyrinth[row][col] = EMPTY_CHAR       # pasa a indicar que queda vacia
        end
      end
    end

    # calcula la posicion a la que se llegaria desde una posicion en una direccion
    def dir_2_pos (row, col, direction)
      
      case direction
      when Directions::UP
        row -= 1

      when Directions::DOWN
        row += 1

      when Directions::LEFT
        col -= 1

      when Directions::RIGHT
        col += 1
      end

      [row,col]
    end

    def put_player_2D(old_row, old_col, row, col, player) 
      output = nil                                  # suponemos que no habra monstruos en la nueva direccion
      if can_step_on(row, col)                      # si puede colocarse en la nueva posicion 
        if pos_ok(old_row, old_col)                 # si la posicion de origen
          p = @players[old_row][old_col]            # obtenemos el jugador que habia en la posicion vieja

          if p.equal?(player)                       # si es el jugador que le pasamos
            update_old_pos(old_row, old_col)        # actualizamos la posicion antigua
            @players[old_row][old_col] = nil        # eliminamos el jugador en la posicion antigua
          end
        end
      
        monster_p = monster_pos(row, col)           # comprobamos que si hay un monstruo en la posicion nueva

        if monster_p                                # si hay monstruo
          @labyrinth[row][col] = COMBAT_CHAR        # pasa a haber un comnbate en el mapa
          output = @monsters[row][col]              # devolvemos al monstruo que hay en la nueva posicion
        else                                        # si no hay monstruo
          @labyrinth[row][col] = player.number      # escribimos el numero del jugador en el mapa
        end

        @players[row][col] = player                 # colocamos al jugador en la posicion nueva
        player.set_pos(row, col)                    # le dmos al jugador su posicion

      end

      output
    end

  end
end