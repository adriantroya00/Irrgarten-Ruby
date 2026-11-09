#encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrian Hernando Leal 

require_relative 'Game'
require_relative 'TextUI'
require_relative 'Controller'

   module Irrgarten
      view = UI::TextUI.new
      game = Game.new(2,false)
      controller = Control::Controller.new(game, view)

      controller.play
   end


