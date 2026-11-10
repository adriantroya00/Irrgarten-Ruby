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
    #Similar a get_
    attr_reader :current_player, :labyrinth
    MAX_ROUNDS = 10                                                     #Atributo de clase constante, si no fuera constante seria @@

    #Inizializaciond de game, se usa new.Game()
    def initialize(n_players,debug)                     
      if(debug)                                                         
        @players = []                                                   #Creamos el array de jugadores
        n_players.times do |i|                                          # usamos como iterador i
          @players << Player.new(i.to_s, 1, 1)                          # añadimos al array jugadores
        end

        @current_player_index = 0                                       # Modificamos el indice de jugador actual
        @current_player = @players[@current_player_index]               # Modificamos el jugador actual con el indice anterior
        
        @monsters = []                                                  # Creamos el array de monstruos
        
        @labyrinth = Labyrinth.new(3, 3, 2, 2)                          # Creamos el laberinto del tamaño y salida al gusto
        
        
        @log = ""                                                       # Un log vacio
        
        configure_labyrinth_debug                                       # Mandamos el laberinto a configurarse
        
        @labyrinth.send(:put_player_2D, -1, -1, 0, 0, @players[0])      # Utilizamos send ya que la funcion es privada para labyrinth
        @labyrinth.send(:put_player_2D, -1, -1, 0, 1, @players[1])      # Aqui forzamos el posicionamiento de los jugadores para probar casos
        
        
      else                                                              # Iniciado normal con aleatoriedad
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
  
        @labyrinth.spread_players(@players)                             # Esparcimos los jugadores aleatoriamente
      end
    end

    # Delega en este metodo ya que game no necesita saber como se gana
    def finished
      @labyrinth.have_a_winner
    end

    # Ejecuta un turno y devuelve true si ha terminado
    def next_step(preferred_direction)
      @log = ""
      dead = @current_player.dead                                     # comprobamos si el jugador esta muerto

      if !dead                                                        
        direction = actual_direction(preferred_direction)             # se calcula la direccion real

        if direction != preferred_direction                           # si difiere lo anota en el log
          log_player_no_orders
        end

        monster = @labyrinth.put_player(direction, @current_player)   # Intenta mover al jugador actual una casilla en la direccion y devuelve el monstruo en esa casilla

        if monster.nil?                                               # si no hay monstruo en la direccioin
          log_no_monster
        else
          winner = combat(monster)                                    # combate contra el monstruo
          manage_reward(winner)                                       # se reparten las recompensas
        end
      else
        manage_resurrection                                           # si el jugador esta muerto se intenta resucitas
      end

      end_game = finished                                             # vemos si el juego ha terminado

      if !end_game                                                    # si el juego continua
        next_player                                                   # pasamos el turno al siguiente jugador
      end

      end_game                                                        # devolvemos si ha terminado el juego
    end
    
    
    def game_state
      labyrinth_str = @labyrinth.to_s
      # players_str = "" + " #{@players.join( " ")}"
      players_str = @players.map(&:to_s).join                         # Recorremos el array de jugadores haciendo el to_s de todos y los juntamos 
      monsters_str = @monsters.map(&:to_s).join                       # como los to_s acaban con \n no tenemos q poner nada en el join, si no join( '\n')
      
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
      @labyrinth.add_block(Orientation::VERTICAL, 1, 1, 2)            # Colocamos un bloque vertical que empieza en fila 1 y columna 1 y dura 2 bloques
      @labyrinth.add_block(Orientation::HORIZONTAL, 3, 2, 2)          # "                   horizontal

      pos1 = @labyrinth.random_empty_pos                              # creamos una posicion random vacia para el primer monstruo
      m1 = Monster.new("Adri", Dice.random_intelligence, Dice.random_strength)  # creamos el monstruo random
      @labyrinth.add_monster(pos1[0], pos1[1], m1)                    # colocamos el monstruo en la posicion random
      @monsters << m1                                                 # lo añadimos tb al mapa de monstruos

      pos2 = @labyrinth.random_empty_pos   # se calcula DESPUÉS de colocar m1
      m2 = Monster.new("Alvaro", Dice.random_intelligence, Dice.random_strength)
      @labyrinth.add_monster(pos2[0], pos2[1], m2)
      @monsters << m2
    end


    def configure_labyrinth_debug
      @labyrinth.add_block(Orientation::VERTICAL, 1, 1, 1)

      m1 = Monster.new("Adri", 2.0, 3.0)                              # monstruos con inteligencia y fuerza forzados
      m2 = Monster.new("Alvaro", 1.5, 2.0)

      @labyrinth.add_monster(1, 0, m1)                                # monstruos colocados a posta
      @labyrinth.add_monster(2, 1, m2)

      @monsters << m1
      @monsters << m2
    end

    def next_player
      @current_player_index = (@current_player_index+1) % @players.length #o @players.size  hacemos esto para no salirnos del nº de jugadores
      @current_player = @players[@current_player_index]
    end
    
    def actual_direction(preferred_direction)
      current_row = @current_player.row                                 # obtenemos la posicion inicial del jugador
      current_col = @current_player.col

      valid_moves = @labyrinth.valid_moves(current_row, current_col)    # creamos un array con los movimientos validos desde la posicion actual

      @current_player.move(preferred_direction, valid_moves)            # movemos al jugador actual a la direccion preferida si se puede, si no a la primera de las validas
    end

    def combat(monster)                                                 # combate contra un monstruo y devuelve un personaje, mosntruo o jugador
      rounds = 0                                                        # inicializamos las rondas de combate a 0
      winner = GameCharacter::PLAYER                                    # empezara ganando el jugador

      player_attack = @current_player.attack                            # jugador ataca
      lose = monster.defend(player_attack)                              # el monstruo se defiende, devuelve true se muere con ese golpe

      while !lose && (rounds < MAX_ROUNDS)                              # mientras nadie haya perdido y no se hayan agotado las rondas
        # turno del monstruo
        winner = GameCharacter::MONSTER                                 # la victoria pasa a monster 
        rounds += 1                                                     # se suma una ronda
        monster_attack = monster.attack                                 # el monstruo ataca al jugador
        lose = @current_player.defend(monster_attack)                   # si el jugador no logra defenderse true

        if !lose                                                        # si el jugador ha logrado defenderse
        # turno del jugador
          player_attack = @current_player.attack                        # el jugador ataca
          winner = GameCharacter::PLAYER                                # la victoria pasa al jugador
          lose = monster.defend(player_attack)                          # si el monstruo muere, lose es true
        end
      end

      log_rounds(rounds, MAX_ROUNDS)
      winner
    end
  
    def manage_reward(winner)
      if winner == GameCharacter::PLAYER                    # si el ganador ha sido el player
        @current_player.receive_reward                      # se le da una recompensa
        log_player_won                                      # registramos la victoria del jugador
      else
        log_monster_won                                     # registramos la victoria del monstruo
      end
    end

    def manage_resurrection()
      resurrect = Dice.resurrect_player                     # pregunamos al dado si el jugador revive

      if resurrect                                          # si revive
        @current_player.resurrect                           # revive el jugador
        log_resurrected                                     # registramos revivir
      else                                                  # si no revive
        log_player_skip_turn                                # el jugador pierde el turno
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