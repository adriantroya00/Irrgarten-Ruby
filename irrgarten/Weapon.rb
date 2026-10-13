module Irrgarten
    # @authors Alvaro Perez Sanchez y Adrián Hernando Leal
    # Tipos de armas existentes en el juego

    class Weapon
        def initialize(power, uses)
            @power = power
            @uses = uses
        end

        def attack
            if @uses > 0
                @uses -= 1
                return @power
            end
            0.0
        end

        def to_s
            "W[#{@power}, #{@uses}]"
        end

        def discard
            Dice.discard_element(@uses)
        end
    end
end
