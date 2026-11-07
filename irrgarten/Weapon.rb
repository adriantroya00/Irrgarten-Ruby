# encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrián Hernando Leal
module Irrgarten
    
    # Tipos de armas existentes en el juego
    require_relative 'Dice'

    class Weapon
        def initialize(power, uses)
            @power = power
            @uses = uses
        end

        def attack
            if @uses > 0
                @uses -= 1
                @power
            else
                0.0
            end
        end

        def to_s
            "W[#{@power}, #{@uses}]"
        end

        def discard
            Dice.discard_element(@uses)
        end

    end
end
