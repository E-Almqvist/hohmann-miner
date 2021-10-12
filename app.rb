#!/usr/bin/ruby -w
require "gosu"
load "physobj.rb"

class Window < Gosu::Window
	attr_accessor :freeze, :caption, :physobjs, :planets
	attr_reader :width, :height

	def initialize(title, width, height, physobjs = [], planets = [])
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@physobjs = physobjs
		@planets = planets

		@font = Gosu::Font.new(self, Gosu::default_font_name, 12)
		@font2 = Gosu::Font.new(self, Gosu::default_font_name, 32)
		@freeze = false
	end

	def button_up(id)
		super id

		if( id == Gosu::KbEscape ) then
			@freeze = !@freeze
		end
	end

	def update
		if( !@freeze ) then
			@physobjs.each do |obj| 
				obj.physics 
			end

			@planets.each do |planet|
				planet.orbit(@physobjs)
			end
		end
	end

	private def generate_debug_string(obj)
		return "\n#{obj.name}\nVel:    #{obj.vel.round(4)} (#{obj.vel.magnitude.round(1)})\nAccel:    #{obj.accel.round(4)} (#{obj.accel.magnitude.round(4)})\nPos:    #{obj.pos.round(4)}\n"
	end

	def draw
		if( @freeze ) then
			@font2.draw("FROZEN", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)
		end

		@physobjs.each do |obj| 
			obj.render
			obj.draw_vector(obj.vel, 10)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa)
			obj.render_path

			@font.draw(self.generate_debug_string(obj), obj.pos[0], obj.pos[1], 1, 1.0, 1.0, Gosu::Color.argb(0xee_aaaaff))
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
cube.pos = Vector[800, 450 + 200]
cube.vel = Vector[2.5, 0]

cube2 = PhysCube.new("Cube2", window, 8, 8)
cube2.pos = Vector[800, 450 + 400]
cube2.vel = Vector[1.25, 0]
planet.orbit([cube, cube2])

window.planets << planet
window.physobjs << cube
window.physobjs << cube2
window.show
