module Irrgarten

   @authors Alvaro Perez Sanchez y Adrián Hernando Leal
   
   class Monster
      @@INITIAL_HEALTH = 5
      @@NO_POS = -1 # esto es por la pregunta del guión sobre si deberiamos añadir algun atributo de clase 

      def initialize(name, intelligence, strength)
         @name = name
         @intelligence = intelligence
         @strength = strength
         @health = @@INITIAL_HEALTH.to_f
         @row = @@NO_POS
         @col = @@NO_POS
      end

      def dead
        @health <= 0.0
      end

      def attack
        Dice.intensity(@strength)
      end

      # def defend(received_attack)

      def to_s
      "Monstruo {\n" +
      "Inteligencia = #{@intelligence}\n" +
      " Fuerza = #{@strength}\n" +
      " Vida = #{@health}\n" +
      " Fila = #{@row}\n" +
      " Columna = #{@col}\n}\n"
      end

      private

      def got_wounded
        @health -= 1
      end
    end
  end