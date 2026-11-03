module Irrgarten

  class Game 
    MAX_ROUNDS = 10;

    def initialize(n_players, n_monsters)
      @players = [];

      for i in 0...n_players
        player = Player.new(
          i.to_s,
          Dice.random_intelligence,
          Dice.random_strength
        )
        @players << player
      end

      @current_player_index = Dice.who_starts(n_players)
      @current_player = @players[current_player_index]

      @monsters = [];

      @labyrinth = Labyrinth.new (5, 5, 4, 4)

      @log = ""

      configure_labyrinth

      #@labyrinth.spread_players(@players)
    
    end

    def finished
      @labyrinth.have_a_winner
    end
    
    def get_game_state
      GameState.new(
        @labyrinth.to_s,
        @players.to_s,
        @monsters.to_s,
        @current_player_index,
        finished,
        @log
      )
    end

    def next_player
      @current_player_index = (@current_player_index+1) % @players.length #o @players.size

      @current_player = @players[current_player_index]
    end

    private

    def configure_labyrinth
      @labyrinth.add_block(Orientation.Vertical, 1, 1, 2)
      @labyrinth.add_block(orientation.Horizontal, 3, 2, 2)

      m1 = Monster.new("Monstruo 1", 2.0, 3.0)
      m2 = Monster.new("Monstruo 2", 1.5, 2.0)

      @labyrinth.add_monster(0, 2, m1)
      @labyrinth.add_monster(2, 3, m2)

      @monsters << m1
      @monsters << m2
    end

    def next_player
      @current_player_index = (@current_player_index+1) % @players.length #o @players.size
      @current_player = @players[current_player_index]
    end
    
    def actual_direction(preferred_direction)
      raise NotImplementedError
    end

    def combat(monster)
      raise NotImplementedError
    end

    def manage_reward(winner)
      raise NotImplementedError
    end

    def manage_resurrection()
      raise NotImplementedError
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
      @log += "Se han producido " + rounds + " de " + max + "rondas de combate\n"
    end





  end
end