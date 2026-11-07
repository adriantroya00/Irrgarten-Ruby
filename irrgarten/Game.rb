# encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrian Hernando Leal

require_relative 'Directions'
require_relative 'Orientation'
require_relative 'GameCharacter'
require_relative 'Dice'
require_relative 'Labyrinth'
require_relative 'Player'
require_relative 'Monster'
require_relative 'GameState'

module Irrgarten
class Game 
    MAX_ROUNDS = 10

    def initialize(n_players, n_monsters)
      @players = []
      n_players.times do |i|                
        @players << Player.new(i.to_s, Dice.random_intelligence, Dice.random_strength)
      end

      @current_player_index = Dice.who_starts(n_players)
      @current_player = @players[@current_player_index]

      @monsters = []

      @labyrinth = Labyrinth.new(5, 5, 4, 4)

      @log = ""

      configure_labyrinth

      @labyrinth.spread_players(@players)
    end

    def finished
      @labyrinth.have_a_winner
    end

    def next_step(preferred_direction)
      @log = ""
      dead = @current_player.dead

      if !dead
        direction = actual_direction(preferred_direction)

        if direction != preferred_direction
          log_player_no_orders
        end

        monster = @labyrinth.put_player(direction, @current_player)

        if monster.nil?
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      else
        manage_resurrection
      end

      end_game = finished

      if !end_game
        next_player
      end

      end_game
    end
    
    
    def game_state
      labyrinth_str = @labyrinth.to_s
      players_str = @players.map(&:to_s).join
      monsters_str = @monsters.map(&:to_s).join
      
      GameState.new(
        labyrinth_str,
        players_str,
        monsters_str,
        @current_player_index,
        finished,
        @log
      )
    end

    private

    def configure_labyrinth
      @labyrinth.add_block(Orientation::VERTICAL, 1, 1, 2)
      @labyrinth.add_block(Orientation::HORIZONTAL, 3, 2, 2)

      m1 = Monster.new("Adri", 2.0, 3.0)
      m2 = Monster.new("Alvaro", 1.5, 2.0)

      @labyrinth.add_monster(0, 2, m1)
      @labyrinth.add_monster(2, 3, m2)

      @monsters << m1
      @monsters << m2
    end

    def next_player
      @current_player_index = (@current_player_index+1) % @players.length #o @players.size
      @current_player = @players[@current_player_index]
    end
    
    def actual_direction(preferred_direction)
      current_row = @current_player.get_row
      current_col = @current_player.get_col

      valid_moves = @labyrinth.valid_moves(current_row, current_col)

      @current_player.move(preferred_direction, valid_moves)
    end

    def combat(monster)
      rounds = 0
      winner = GameCharacter::PLAYER

      player_attack = @current_player.attack

      lose = monster.defend(player_attack)

      while !lose && (rounds < MAX_ROUNDS)
        winner = GameCharacter::MONSTER
        rounds += 1

        monster_attack = monster.attack
        
        lose = @current_player.defend(monster_attack)

        if !lose
          player_attack = @current_player.attack
          winner = GameCharacter::PLAYER
          lose = monster.defend(player_attack)
        end
      end

      log_rounds(rounds, MAX_ROUNDS)

      winner
    end
  
    def manage_reward(winner)
      if winner == GameCharacter::PLAYER
        @current_player.receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    def manage_resurrection()
      resurrect = Dice.resurrect_player

      if resurrect
        @current_player.resurrect
        log_resurrected
      else
        log_player_skip_turn
      end
    end

    def log_player_won
      @log += "El jugador ha ganado el combate\n"
    end

    def log_monster_won
      @log += "El monstruo ha ganado el combate\n"
    end

    def log_resurrected
      @log += "El jugador ha resucitado\n"
    end

    def log_player_skip_turn
      @log += "El jugador ha perdido el turno al estar muerto\n"
    end

    def log_player_no_orders
      @log += "El jugador no ha seguido las instrucciones (no fue posible)\n"
    end

    def log_no_monster
      @log += "El jugador se ha movido a una celda vacia o no le fue posible moverse\n"
    end

    def log_rounds(rounds, max)
      @log += "Se han producido #{rounds}  de #{max} rondas de combate\n"
    end
  end
end