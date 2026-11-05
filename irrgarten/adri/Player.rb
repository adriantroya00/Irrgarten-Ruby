# enconding: UTF-8
@authors Alvaro Perez Sanchez y Adrián Hernando Leal

require_relative 'Dice'
require_relative 'Weapon'
require_relative 'Shield'

module Irrgarten
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

  def move(direction, valid_moves)
    size = valid_moves.size
    contained = valid_moves.include?(direction)

    if size > 0 && !contained
      valid_moves.first
    else
      direction
    end
  end
  
  def attack
    @strength + sum_weapons
  end

  def defend(received_attack)
    manage_hit(received_attack)
  end

  def receive_reward
    w_reward = Dice.weapons_reward
    s_rewarc = Dice.shields_reward

    w_reward.times do
      wnew = new_weapon
      receive_weapon(wnew)
    end

    s_rewarc.times do
      snew = new_shield
      receive_shield(snew)
    end

    extra_health = Dice.health_reward
    @health += extra_health
  end  

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

    def receive_weapon(w)
      # delete_if equivale al iterator.remove
      @weapons.delete_if { |wi| wi.discard }

      if @weapons.size < MAX_WEAPONS
        @weapons << w
      end
    end   
    
    
    def receive_shield(s)
      # delete_if equivale al iterator.remove
      @shields.delete_if { |si| si.discard }

      if @shields.size < MAX_SHIELDS
        @shields << s 
      end
    end

    def new_weapon
      Weapon.new(Dice.weapon_power, Dice.uses_left)
    end

    def new_shield
      Shield.new(Dice.shield_power, Dice.uses_left)
    end

    def defensive_energy
      @intelligence + sum_shields
    end

    def manage_hit(received_attack)
      defense = defensive_energy

      if defense < received_attack
        got_wounded
        inc_consecutive_hits
      else
        reset_hits
      end

      if @consecutive_hits == HITS2LOSE || dead
        reset_hits
        lose = true
      else
        lose = false
      end

      lose
    end

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
      sum_total = 0.0
      @weapons.each do |weapon|
        sum_total += weapon.attack unless weapon.nil? # unless es el contrario de if
      end
      sum_total
    end

    def sum_shields
      sum_total = 0.0
      @shields.each do |shield|
        sum_total += shield.protect unless shield.nil? # unless es el contrario de if
      end
      sum_total
    end
  end
end
  
