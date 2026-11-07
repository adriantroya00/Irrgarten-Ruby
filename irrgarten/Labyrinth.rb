# encoding: UTF-8

module Irrgarten
  # @author Alvaro Perez Sanchez
  # @author Adrian Hernando Leal
  require_relative 'Dice'
  require_relative 'Directions'
  require_relative 'Orientation'

  class Labyrinth
    BLOCK_CHAR    = 'X'
    EMPTY_CHAR    = '-'
    MONSTER_CHAR  = 'M'
    COMBAT_CHAR   = 'C' #tiene a la vez monstruo y jugador
    EXIT_CHAR     = 'E'
    ROW = 0
    COL = 1

    def initialize(n_rows, n_cols, exit_row, exit_col)
      @n_rows = n_rows
      @n_cols = n_cols
      @exit_row = exit_row
      @exit_col = exit_col

      @labyrinth = Array.new(@n_rows){ Array.new(@n_cols, EMPTY_CHAR)}
      @monsters = Array.new(@n_rows){ Array.new(@n_cols)}
      @players = Array.new(@n_rows){ Array.new(@n_cols)}

      @labyrinth[exit_row][exit_col] = EXIT_CHAR
    end

    def spread_players(players)
      players.each do |p|
        pos = random_empty_pos
        put_player_2D(-1, -1, pos[ROW], pos[COL], p)
      end
    end

    def have_a_winner
      @players[@exit_row][@exit_col] != nil
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
      if pos_ok(row, col) && empty_pos(row,col)
        @labyrinth[row][col] = MONSTER_CHAR
        @monsters[row][col] = monster
        monster.set_pos(row, col)
      end
    end

    def put_player(direction, player)
      old_row = player.get_row()
      old_col = player.get_col()

      new_pos = dir_2_pos(old_row, old_col, direction)
      monster = put_player_2D(old_row, old_col, new_pos[ROW], new_pos[COL], player)
      
      monster
    end

    def add_block(orientation, start_row, start_col, length)
      if orientation == Orientation::VERTICAL
        inc_row = 1
        inc_col = 0
      else
        inc_row = 0
        inc_col = 1
      end
      row = start_row
      col = start_col

      while pos_ok(row, col) && (empty_pos(row, col) && (length > 0))
        @labyrinth[row][col] = BLOCK_CHAR

        length -= 1
        row += inc_row
        col += inc_col
      end
    end

    def valid_moves(row, col)
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

    def can_step_on(row, col)
      pos_ok(row, col) &&
      (monster_pos(row, col) ||
      exit_pos(row, col) ||
      empty_pos(row, col))
    end

    def update_old_pos(row, col)
      if pos_ok(row, col)
        if combat_pos(row, col)
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

    def put_player_2D(old_row, old_col, row, col, player)
      output = nil
      if can_step_on(row, col)
        if pos_ok(old_row, old_col)
          p = @players[old_row][old_col]

          if p.equal?(player)
            update_old_pos(old_row, old_col)
            @players[old_row][old_col] = nil
          end
        end
      
        monster_p = monster_pos(row, col)

        if monster_p
          @labyrinth[row][col] = COMBAT_CHAR
          output = @monsters[row][col]
        else 
          @labyrinth[row][col] = player.get_number
        end

        @players[row][col] = player
        player.set_pos(row, col)

      end

      output
    end

  end
end