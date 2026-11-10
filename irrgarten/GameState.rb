# encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrian Hernando Leal
module Irrgarten

  class GameState
    # trabajar con los .__ no con los getters
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

    # NO deberia usarse si tenemos los attr_reader
    def winner?
      @winner
    end

    def get_labyrinth
      @labyrinth
    end

    def get_players
      @players
    end


    def get_monsters
      @monsters
    end

    def get_current_player
      @current_player
    end

    def get_log
      @log
    end

  end
end