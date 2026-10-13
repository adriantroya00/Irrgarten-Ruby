# TESTP1.rb

require_relative "Weapon"
require_relative "Shield"
require_relative "GameState"
require_relative "Dice"
require_relative "Directions"
require_relative "Orientation"
require_relative "GameCharacter"

# ======================================================
# 1. Prueba Weapon
# ======================================================
puts "==== PRUEBAS ESPADA ===="

espada = Weapon.new(5,5)
usable_1 = true

begin
  puts "La espada ataca con #{espada.attack}"

  if espada.discard
    puts "No se descartó la espada"
    puts espada
  else 
    puts "Se descartó la espada"
    usable_1 = false
  end
end while usable_1

# ======================================================
# 2. Prueba Shield
# ======================================================
puts "==== PRUEBAS ESCUDO ===="

escudo = Shield.new(3,3)
usable_2 = true

begin
  puts "El escudo defiende con #{escudo.defense}"

  if escudo.discard
    puts "No se descartó el escudo"
    puts escudo
  else 
    puts "Se descartó el escudo"
    usable_2 = false
  end
end while usable_2

# ======================================================
# 2. Prueba GameState
# ======================================================
puts "==== PRUEBAS GAMESTATE ===="

gs = GameState.new("lab1", "jugadores", "monstruos", 0, false, "log inicial")

puts "El laberinto es: #{gs.labyrinth}"
puts "Los jugadores son: #{gs.players}"
puts "Los monstruos son: #{gs.monsters}"
puts "El jugador actual es: #{gs.current_player}"
puts "El ganador es: #{gs.winner}"
puts "El log es: #{gs.log}"

# ======================================================
# 4. Prueba Enumerados
# ======================================================
puts "==== PRUEBAS ENUMERADOS ===="

dir = Directions::LEFT
ori = Orientation::VERTICAL
gc = GameCharacter::MONSTER

puts "La dirección es: #{dir}"
puts "La orientación es: #{ori}"
puts "El carácter de juego es: #{gc}"

puts "Todas las direcciones:"
Directions.values.each do |direccion|
    puts "La dirección es: #{direccion}"
end

puts "Todas las orientaciones:"
Orientation.values.each do |orientacion|
    puts "La orientación es: #{orientacion}"
end

puts "Todas los tipos de personajes:"
GameCharacter.values.each do |personaje|
    puts "El carácter de juego es: #{personaje}"
end

# ======================================================
# 5. Pruebas Dice
# ======================================================
puts "========= PRUEBAS ENUMERADOS (100 pruebas por metodo)====="

# randomPos
puts "Dirección aleatoria: #{Dice.random_pos(5)}"

# whoStarts
100.times do
    puts "Empieza el jugador: #{Dice.who_starts(3)}"
end

# randomIntelligence y randomStrength
100.times do
    puts "Inteligencia: #{Dice.random_intelligence}"
    puts "Fuerza: #{Dice.random_strength}"
end

# resurrectPlayer
resurrect_count = 0

100.times do
    resurrect_count += 1 if Dice.resurrect_player
end

puts "Veces resucitadas: #{resurrect_count}"

# weaponsReward, shieldsReward, healthReward
100.times do |i|
    puts "------ #{i} ------"
    puts "Armas: #{Dice.weapons_reward}"
    puts "Escudos: #{Dice.shields_reward}"
    puts "Vida: #{Dice.health_reward}"
end

# weaponPower, shieldPower
100.times do |i|
    puts "------ #{i} ------"
    puts "Poder Arma: #{Dice.weapon_power}"
    puts "Poder Escudo: #{Dice.shield_power}"
end

# usesLeft
100.times do |i|
    puts "------ #{i} ------"
    puts "El objeto empezara con: #{Dice.uses_left} usos"
end

# intensity
100.times do |i|
    puts "------ #{i} ------"
    puts "Se usara una intensidad de: #{Dice.intensity(5)} usos"
end

# discardElement
discard_count = 0

10_000.times do
    discard_count += 1 if Dice.discard_element(0)
end

puts "Veces descartado: #{discard_count}"



