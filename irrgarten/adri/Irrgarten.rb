/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Main.java to edit this template
 */

#encoding: UTF-8
# @author Alvaro Perez Sanchez
# @author Adrian Hernando Leal 

require_relative 'Game'
require_relative 'textUI'
require_relative 'controller'

   module Irrgarten
      view = UI::textUI.new
      game = Game.new(2,2)
      controller = Control::Controller.new(game, view)

      controller.play
   end


