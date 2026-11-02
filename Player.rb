module Irrgarten
  @authors Alvaro Perez Sanchez y Adrián Hernando Leal

  class Player
    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 10
    @@HITS2LOSE = 3
    @@NO_POS = -1 # esto es por la pregunta del guión sobre si deberiamos añadir algun atributo de clase

    attr_reader :row, :col, :number # esto equivale a los get row, col y number (debemos ponerlo en java)

    def initialize(number, intelligence, strength)
      @number = number
      @name = "Player ##{@number}"
      @intelligence = intelligence
      @strength = strength
      @health = @@INITIAL_HEALTH.to_f
      @row = @@NO_POS
      @col = @@NO_POS
      @consecutive_hits = 0
      @weapons = [] # crean arrays vacios
      @shields = [] # crean arrays vacios
    end

  def resurrect
    @weapons.clear
    @shields.clear
    @health = @@INITIAL_HEALTH.to_f
    @consecutive_hits = 0
  end

  def set_pos(row, col)
    @row = row
    @col = col
  end

  def dead
    @health <= 0.0
  end

  # def move(direction, valid_moves)
  
  def attack
    @strength + sum_weapons
  end

  def defend(received_attack)
    manage_hit(received_attack)
  end

  # def receive_reward

  def to_s
     "Jugador {\n" +
      " Nombre = #{@name}\n" +
      " Numero = #{@number}\n" +
      " Inteligencia = #{@intelligence}\n" +
      " Fuerza = #{@strength}\n" +
      " Vida = #{@health}\n" +
      " Fila = #{@row}\n" +
      " Columna = #{@col}\n" +
      " Hits Consecutivos = #{@consecutive_hits}\n}\n"
    end

    private

    # def receive_weapon(w)

    # def receive_shield(s)

    def new_weapon
      Weapon.new(Dice.weapon_power, Dice.uses_left)
    end

    def new_shield
      Shield.new(Dice.shield_power, Dice.uses_left)
    end

    def defensive_energy
      @intelligence + sum_shields
    end

    # def manage_hit(received_attack)

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
      @weapons.sum(0.0) { |weapon| weapon.attack } # recorre array, se aplica el bloque a cada elemento y suma resultados (echale un vistazo por si acaso)
    end

    def sum_shields
      @shields.sum(0.0) { |shield| shield.defend } # recorre array, se aplica el bloque a cada elemento y suma resultados (echale un vistazo por si acaso)
    end
  end
end
  
