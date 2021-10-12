#!/usr/bin/ruby -w
require "gosu"
load "physobj.rb"

class Window < Gosu::Window
	attr_accessor :freeze, :caption, :physobjs, :planets, :controller
	attr_reader :width, :height, :fonts

	def initialize(title, width, height, physobjs = [], planets = [])
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@physobjs = physobjs
		@planets = planets

		@font = Gosu::Font.new(self, Gosu::default_font_name, 14)
		@font2 = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@fonts = {
			normal: @font,
			big: @font2
		}

		@freeze = false
		@controller = nil
	end

	def button_up(id)
		super id

		if( @controller != nil ) then
			@controller.button_up(id)
		end

		if( id == Gosu::KbEscape ) then
			@freeze = !@freeze
		end
	end

	def button_down(id)
		super id

		if( @controller != nil ) then
			@controller.button_down(id)
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
		return "\n#{obj.name}\nVel: #{obj.vel.round(4)} (#{obj.vel.magnitude.round(1)})\nAccel: #{obj.accel.round(4)} (#{obj.accel.magnitude.round(4)})\nPos: #{obj.pos.round(4)}\n"
	end

	def draw
		@font2.draw("Frozen: #{@freeze}", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)

		@physobjs.each do |obj| 
			obj.render
			obj.draw_vector(obj.vel, 10)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa)
			obj.render_path
			obj.draw_direction
		end

		@planets.each do |planet|
			planet.render
		end
	end
end


window = Window.new("Physics!", 1600, 900)

planet = Planet.new("Sol", window, 0xff_ffffaa, 1e2, 20, 120)
planet.pos = Vector[800, 450]
planet.show_info = true

cube = Player.new("Alpha", window, 8, 8)
cube.show_info = true
cube.thrust = 0.0075
cube.pos = Vector[800, 450 + 200]
cube.vel = Vector[2.5, 0]
window.controller = cube

cube2 = PhysCube.new("Beta", window, 8, 8)
cube2.pos = Vector[800, 450 + 300]
cube2.vel = Vector[-2.5, 0]

planet.orbit([cube, cube2])

window.planets << planet
window.physobjs << cube
window.physobjs << cube2
window.show
