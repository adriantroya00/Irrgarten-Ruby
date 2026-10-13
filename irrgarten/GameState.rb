# encoding: UTF-8

module Irrgarten
  # @authors Alvaro Perez Sanchez y Adrian Hernando Leal
  class GameState
    attr_reader :labyrinth, :players, :monsters, :current_player, :winner, :log

    # labyrinth: mapa
    # players: información de los jugadores
    # monsters: información de los monstruos
    # current_player: índice del jugador actual
    # winner: si hay ganador
    # log: registro de sucesos
    def initialize(labyrinth, players, monsters, current_player, winner, log)
      @labyrinth = labyrinth
      @players = players
      @monsters = monsters
      @current_player = current_player
      @winner = winner
      @log = log
    end

    # Equivalente a isWinner() de Java
    def winner?
      @winner
    end
  end
end