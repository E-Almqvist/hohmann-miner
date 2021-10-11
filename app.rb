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
		end
	end
end


window = Window.new("Physics!", 1600, 900)

planet = PhysCube.new(window, 16, 16, 0xff_aaffaa)

cube = PhysCube.new(window, 8, 8)
cube.accel = Vector[0, 0.1]
cube.vel = Vector[0.01, 0]

window.physobjs << cube
window.show
