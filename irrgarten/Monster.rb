module Irrgarten
  # @author Alvaro Perez Sanchez 
  # @author Adrián Hernando Leal

  require_relative 'Dice'

  class Monster
    INITIAL_HEALTH = 5
    NO_POS = -1 # esto es por la pregunta del guión sobre si deberiamos añadir algun atributo de clase 

    def initialize(name, intelligence, strength)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = INITIAL_HEALTH.to_f
      @row = NO_POS
      @col = NO_POS
    end

    def dead
      @health <= 0.0
    end

    def attack
      Dice.intensity(@strength)
    end

    def defend(received_attack)
      is_dead = dead()
      
      if !is_dead
        defensive_energy = Dice.intensity(@intelligence)

        if defensive_energy < received_attack
          got_wounded()
          is_dead = dead()
        end
      end
        is_dead
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      "Monstruo {
      Nombre = #{@name}
      Inteligencia = #{@intelligence}
      Fuerza = #{@strength}
      Vida = #{@health}
      Fila = #{@row}
      Columna = #{@col}
      }\n"
    end
  private
    def got_wounded
      @health -= 1
    end
  end

end