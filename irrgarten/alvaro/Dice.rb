# encoding: UTF-8

module Irrgarten
  # @authors Alvaro Perez Sanchez y Adrian Hernando Leal
  class Dice
    MAX_USES = 5                # Número máximo de usos de armas y escudos
    MAX_INTELLIGENCE = 10.0     # Valor máximo para la inteligencia de jugadores y monstruos
    MAX_STRENGTH = 10.0         # Valor máximo para la fuerza de jugadores y monstruos
    RESURRECT_PROB = 0.3        # Probabilidad de que un jugador sea resucitado en cada turno
    WEAPONS_REWARD = 2          # Número máximo de armas recibidas al ganar un combate
    SHIELDS_REWARD = 3          # Número máximo de escudos recibidos al ganar un combate
    HEALTH_REWARD = 5           # Número máximo de unidades de salud recibidas al ganar un combate
    MAX_ATTACK = 3              # Máxima potencia de las armas
    MAX_SHIELD = 2              # Máxima potencia de los escudos

    GENERATOR = Random.new

    # Fila/columna aleatoria en [0, max)
    def self.random_pos(max)
      GENERATOR.rand(max)
    end

    # Índice del jugador que empieza (los jugadores se numeran desde 0)
    def self.who_starts(nplayers)
      GENERATOR.rand(nplayers)
    end

    # Inteligencia aleatoria en [0, MAX_INTELLIGENCE]
    def self.random_intelligence
      GENERATOR.rand * MAX_INTELLIGENCE
    end

    # Fuerza aleatoria en [0, MAX_STRENGTH]
    def self.random_strength
      GENERATOR.rand * MAX_STRENGTH
    end

    # Si un jugador muerto debe ser resucitado o no
    def self.resurrect_player
      GENERATOR.rand < RESURRECT_PROB
    end

    # Armas recibidas al ganar el combate
    def self.weapons_reward
      GENERATOR.rand(WEAPONS_REWARD)
    end

    # Escudos recibidos al ganar el combate
    def self.shields_reward
      GENERATOR.rand(SHIELDS_REWARD)
    end

    # Vida recibida al ganar el combate
    def self.health_reward
      GENERATOR.rand(HEALTH_REWARD)
    end

    # Potencia de un arma en [0, MAX_ATTACK]
    def self.weapon_power
      GENERATOR.rand * MAX_ATTACK
    end

    # Potencia de un escudo en [0, MAX_SHIELD]
    def self.shield_power
      GENERATOR.rand * MAX_SHIELD
    end

    # Usos que se asignarán a un arma/escudo
    def self.uses_left
      GENERATOR.rand(MAX_USES)
    end

    # Competencia aplicada, valor aleatorio en [0, competence]
    def self.intensity(competence)
      GENERATOR.rand * competence
    end

    # Comprueba si se descarta un arma/escudo al usarlo
    def self.discard_element(uses_left)
      GENERATOR.rand(MAX_USES) >= uses_left
    end
  end
end