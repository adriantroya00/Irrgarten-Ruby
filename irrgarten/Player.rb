# encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrian Hernando Leal 


require_relative 'Dice'
require_relative 'Weapon'
require_relative 'Shield'

module Irrgarten
  class Player
    #health solo se utilizan para el test de reanimar
    attr_writer :health
    attr_reader :row, :col, :number   # sirven para saber la posicion del jugador y q numero es para el mapa

    MAX_WEAPONS = 2                 # maximo numero de armas por jugador
    MAX_SHIELDS = 3                 # maximo numero de escudos por jugador
    INITIAL_HEALTH = 10             # salud inicial del jugador
    HITS2LOSE = 3                   # golpes consecutivos para retirarse del combate
    NO_POS = -1                     # añadimos un atributo de clase extra para las posiciones fuera del tablero

    def initialize(number, intelligence, strength)
      @number = number              # numero del jugador
      @name = "Player ##{@number}"  # nombre del jugador
      @intelligence = intelligence  # defensa
      @strength = strength          # fuerza
      @health = INITIAL_HEALTH.to_f # salud inicial
      @row = NO_POS                 # fila inicial
      @col = NO_POS                 # columna inicial
      @consecutive_hits = 0         # golpes consecutivos
      @weapons = []                 # crean arrays vacios
      @shields = []                 # crean arrays vacios
    end

  def resurrect
    @weapons.clear                  # vaciamos las armas
    @shields.clear                  #    "     los escudos
    @health = INITIAL_HEALTH.to_f   # restauramos la salud
    @consecutive_hits = 0           # reiniciamos los golpes consecutivos recibidos
  end

  def set_pos(row, col)             # coloca un jugador
    @row = row
    @col = col
  end

  def dead                          # comprobamos si ha muerto el jugador
    @health <= 0.0
  end

  def move(direction, valid_moves)                # recibe una direccion y una lista con los movimientos validos
    size = valid_moves.size                       # comprobamos cuantos movimientos validos hay
    contained = valid_moves.include?(direction)   # comprobamos si la direccion pedida es valida

    if size > 0 && !contained                     # si hay posiciones validas pero no esta la pasada
      valid_moves.first                           # devolvemos la primera direccion valida
    else                                          # si la direccion es valida o no hay movimientos posibles
      direction                                   # devolvemos la direccion pedida, si no es valida se encargara put_player_2d de no mover al jugador
    end
  end
  
  def attack
    @strength + sum_weapons                       # suma de fuerza base mas lo que aporta cada arma
  end

  def defend(received_attack)
    manage_hit(received_attack)                   # delega en manage_hit
  end

  def receive_reward
    w_reward = Dice.weapons_reward                # preguntamos al dado cuantas armas o escudos le tocan
    s_reward = Dice.shields_reward

    w_reward.times do                             # para cada numero de armas 
      wnew = new_weapon                           # se crea el arma
      receive_weapon(wnew)                        # el jugador recibe el arma
    end

    s_reward.times do                             # igual con los escudos
      snew = new_shield
      receive_shield(snew)
    end

    extra_health = Dice.health_reward             # añadimos la vida extra que gane el jugador
    @health += extra_health
  end  

  def to_s
      "Jugador {
      Nombre = #{@name}
      Numero = #{@number}
      Inteligencia = #{@intelligence}
      Fuerza = #{@strength}
      Vida = #{@health}
      Fila = #{@row}
      Columna = #{@col}
      Hits Consecutivos = #{@consecutive_hits}
      Armas = #{@weapons.join(' ')}
      Escudos = #{@shields.join(' ')}
      }\n"
    end

    private

    def receive_weapon(w)
      # eliminamos las armas que se tengan q descartar
      @weapons.delete_if { |wi| wi.discard }

      # si caben armas añadimos el arma
      if @weapons.size < MAX_WEAPONS
        @weapons << w
      end
    end   
    
    
    def receive_shield(s)
      # delete_if equivale al iterator.remove
      @shields.delete_if { |si| si.discard }

      if @shields.size < MAX_SHIELDS
        @shields << s 
      end
    end

    # creamos armas y escudos con estadisticas aleatorias del dado
    def new_weapon
      Weapon.new(Dice.weapon_power, Dice.uses_left)
    end

    def new_shield
      Shield.new(Dice.shield_power, Dice.uses_left)
    end

    # sumamos las defensas del personaje mas las de los escudos
    def defensive_energy
      @intelligence + sum_shields
    end

    def manage_hit(received_attack)
      defense = defensive_energy        # obtenemos la fuerza de la defensa

      if defense < received_attack                # si no es suficiente la defensa
        got_wounded                               # bajamos uno de vida al personaje
        inc_consecutive_hits                      # incrementamos el numero de hits consecutivos
      else                                        # si defiende el ataque
        reset_hits                                # reiniciamos el numero de hits consecutivos
      end

      if @consecutive_hits == HITS2LOSE || dead   # si los hits consecutivos llegan al maximo o muere
        reset_hits                                # reiniciamos la racha
        lose = true                               # el jugador muere
      else                                        # si no se llega a los hits ni muere
        lose = false                              # el jugador no muere
      end

      lose
    end

    def reset_hits                                
      @consecutive_hits = 0
    end

    def got_wounded
      @health -= 1
    end

    def inc_consecutive_hits
      @consecutive_hits += 1
    end

    def sum_weapons
      sum_total = 0.0
      @weapons.each do |weapon|               # recorremos el array de armas 
        if !weapon.nil?                       # si hay arma
          sum_total += weapon.attack          # acumulamos el ataque
        end
      end
      sum_total
    end

    def sum_shields
      sum_total = 0.0
      @shields.each do |shield|
        if !shield.nil?
          sum_total += shield.protect 
        end
      end
      sum_total
    end

  end
end
  
