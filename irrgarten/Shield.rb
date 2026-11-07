# encoding: UTF-8

module Irrgarten
  # @author Alvaro Perez Sanchez 
  # @author Adrian Hernando Leal
  
  require_relative 'Dice'
  
  class Shield
    def initialize(protection, uses)
      @protection = protection
      @uses = uses
    end

    def protect
      if @uses > 0
        @uses -= 1
        @protection
      else
        0.0
      end
    end

    def to_s
      "S[#{@protection}, #{@uses}]"
    end

    def discard
      Dice.discard_element(@uses)
    end
  end
end