#!/usr/bin/ruby -w
require "gosu"
load "physobj.rb"

class Window < Gosu::Window
	attr_accessor :caption, :physobjs
	attr_reader :width, :height

	def initialize(title, width, height, physobjs = [])
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@physobjs = physobjs
	end

	def update
		@physobjs.each do |obj| 
			obj.physics 
		end
	end

	def draw
		@physobjs.each do |obj| 
			obj.render
			obj.draw_vector(obj.vel, 10)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa)
		end
	end
end


window = Window.new("Physics!", 1600, 900)

planet = PhysCube.new("Earth", window, 16, 16, 0xff_aaffaa)
planet.pos = Vector[800, 450]

cube = PhysCube.new("Cube", window, 8, 8)
cube.accel = Vector[0, 0.1] 
cube.vel = Vector[10, 0]

window.physobjs << planet
window.physobjs << cube
window.show
