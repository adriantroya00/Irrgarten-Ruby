module Irrgarten

class Labyrinth
  BLOCK_CHAR = 'X';
  EMPTY_CHAR = '-',
  MONSTER_CHAR = 'M',
  COMBAT_CHAR = 'C', #tiene a la vez monstruo y jugador
  EXIT_CHAR = 'E';
  ROW = 0;
  COL = 1;

  def initialize(n_rows, n_cols, exit_row, exit_col)
    @n_rows = n_rows
    @n_cols = n_cols
    @exit_row = exit_row
    @exit_col = exit_col
  end

  def spread_players(players)
    raise NotImplementedError
  end

  def have_a_winner
    @players[@exit_row][@exit_col] != nil
  end

  def to_s
    "Laberinto {" + 
    "\n Numero de Filas = " + @n_rows + 
    "\n Numero de Columnas = " + @n_cols + 
    "\n Fila de salida = " + @exit_row + 
    "\n Columna de salida = " + @exit_col + 
    "\n}\n"
  end

  def add_monster(row, col, monster)
    if pos_ok(row, col) && empty_pos(row,col)
      @labyrinth[row][col] = MONSTER_CHAR
      @monsters[row][col] = monster
      monster.set_pos(row, col)
    end
  end

  def put_player(direction, player)
    raise NotImplementedError
  end

  def add_block(orientation, start_row, start_col, length)
    raise NotImplementedError
  end

  def valid_moves(row, col)
    raise NotImplementedError
  end

  private

  def pos_ok(row, col)
    0 <= row && row <= @n_rows &&
    0 <= col && col <= @n_cols
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

  def can_step_on(row, col)
    pos_ok(row, col) &&
    monster_pos(row, col) ||
    exit_pos(row, col) ||
    empty_pos(row, col)
  end

  def update_old_pos(row, col)
    if pos_ok(row, col)
      if @labyrinth[row][col] == COMBAT_CHAR
        @labyrinth[row][col] = MONSTER_CHAR
      else
        @labyrinth[row][col] = EMPTY_CHAR
      end
    end
  end

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

  def random_empty_pos
    begin
      row = Dice.random_pos(@n_rows)  
      col = Dice.random_pos(@n_cols)
    end until empty_pos(row, col)

    [row, col]
  end

  def put_play_2D
    raise NotImplementedError
  end

end