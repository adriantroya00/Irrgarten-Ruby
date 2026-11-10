module Irrgarten
  # @author Alvaro Perez Sanchez 
  # @author Adrián Hernando Leal

  require_relative 'Dice'

  class Monster
    INITIAL_HEALTH = 5                              # salud inicial del monstruo
    NO_POS = -1                                     # añadimos un atributo de clase para decir que la posicion no es valida  

    def initialize(name, intelligence, strength)
      @name = name                                  # nombre del monstruo
      @intelligence = intelligence                  # inteligencia  
      @strength = strength                          # fuerza
      @health = INITIAL_HEALTH.to_f                 # salud
      @row = NO_POS                                 # posicion
      @col = NO_POS
    end

    def dead                                        # comprobamos si ha muerto
      @health <= 0.0
    end

    def attack                                      # el dado elige la intensidad con la que ataca el monstruo
      Dice.intensity(@strength)
    end

    def defend(received_attack)
      is_dead = dead()                                    # comprobamos si el monstruo esta muerto
      
      if !is_dead                                         # si sigue vivo
        defensive_energy = Dice.intensity(@intelligence)  # calculamos su energia defensiva entre [0, inteligencia)

        if defensive_energy < received_attack             # si no defiende el ataque
          got_wounded()                                   # recibe daño
          is_dead = dead()                                # comprobamos si esta muerto
        end
      end                                                 # si esta muerto
        is_dead                                           # devolvemos true si esta muerto o muere a consecuencia del ataque
    end

    def set_pos(row, col)               # para darle la posicion al monstruo
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
    def got_wounded                 # resta 1 de salud 
      @health -= 1
    end
  end

end