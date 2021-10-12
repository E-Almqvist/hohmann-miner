#!/usr/bin/ruby -w
require "gosu"
load "physobj.rb"

class Window < Gosu::Window
	attr_accessor :caption, :physobjs, :planets
	attr_reader :width, :height

	def initialize(title, width, height, physobjs = [], planets = [])
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@physobjs = physobjs
		@planets = planets
	end

	def update
		@physobjs.each do |obj| 
			obj.physics 
		end

		@planets.each do |planet|
			planet.orbit(@physobjs)
		end
	end

	def draw
		@physobjs.each do |obj| 
			obj.render
			obj.draw_vector(obj.vel, 10)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa)
		end

		@planets.each do |planet|
			planet.render
		end
	end
end


window = Window.new("Physics!", 1600, 900)

planet = Planet.new("Earth", window, 0xff_aaffaa)
planet.pos = Vector[800, 450]

cube = PhysCube.new("Cube", window, 8, 8)
cube.vel = Vector[10, 0]
planet.orbit([cube])

window.planets << planet
window.physobjs << cube
window.show
