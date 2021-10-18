#!/usr/bin/ruby -w
require "matrix"
require "gosu"
load "gosu_plugin.rb"

load "physobj.rb"
load "controller.rb"
load "planet.rb"

class Window < Gosu::Window
	attr_accessor :freeze, :caption, :physobjs, :planets, :controller, :camera
	attr_reader :width, :height, :fonts

	def initialize(title, width, height, physobjs = [], planets = [])
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@physobjs = physobjs
		@planets = planets

		@font = Gosu::Font.new(self, Gosu::default_font_name, 18)
		@font2 = Gosu::Font.new(self, Gosu::default_font_name, 20)

		@fonts = {
			normal: @font,
			big: @font2
		}

		@freeze = false
		@controller = nil

		@camera = Vector[0, 0]
	end

	def button_up(id)
		super id

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_up(id)
		end
	end

	def button_down(id)
		super id

		if( id == Gosu::KbEscape ) then
			@freeze = !@freeze
		end

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_down(id)
		end
	end

# 	def button_up?(id)
# 		super id
# 
# 		if( @controller != nil && @controller.class == Player ) then
# 			@controller.button_up?(id)
# 		end
# 	end
# 
# 	def button_down?(id)
# 		super id
# 
# 		if( @controller != nil && @controller.class == Player ) then
# 			@controller.button_down?(id)
# 		end
# 	end

	def update
		if( !@freeze ) then
			@physobjs.each do |obj| 
				obj.physics 
			end

			@planets.each do |planet|
				orbiters = []
				orbiters += @physobjs
				orbiters += @planets
				orbiters.delete(planet)
				planet.orbit(planets)
			end
		end
	end

	private def generate_debug_string(obj)
		return "\n#{obj.name}\nVel: #{obj.vel.round(4)} (#{obj.vel.magnitude.round(1)})\nAccel: #{obj.accel.round(4)} (#{obj.accel.magnitude.round(4)})\nPos: #{obj.pos.round(4)}\n"
	end

	def draw
		if( @controller != nil ) then
			@camera = Vector[self.width/2, self.height/2] - @controller.pos 
			@font.draw_text(@controller.debug_string, 0, 32, 1, 1.0, 1.0, Gosu::Color::WHITE)
		end
		camx, camy = @camera[0], @camera[1]
		p @camera

		@font2.draw_text("Frozen: #{@freeze}", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)

		@physobjs.each do |obj| 
			obj.render(camx, camy)
			obj.draw_vector(obj.vel, 10, 0xff_ffaaaaa, camx, camy)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa, camx, camy)
			obj.render_path(camx, camy)
			obj.draw_direction(camx, camy)
		end

		@planets.each do |planet|
			planet.render(camx, camy)
		end
	end
end


window = Window.new("Physics!", 1600, 900)

cube = Player.new("Alpha", window, 8, 8)
cube.show_info = false 
cube.thrust = 0.0075
cube.pos = Vector[800, 450 + 200]
cube.vel = Vector[2.5, 0]
window.controller = cube 

cube2 = PhysCube.new("Beta", window, 8, 8)
cube2.pos = Vector[800, 450 + 300]
cube2.vel = Vector[2, 0]
cube2.show_info = true

sol = Planet.new("Sol", window, 0xff_ffffaa, 1e2, 15, 1)
sol.pos = Vector[800, 450]

planet = Planet.new("Planet", window, 0xff_cccccc, 1e1, 8, 1)
planet.pos = Vector[800, 450 + 300]
planet.vel = Vector[-2, 0]
planet.show_info = true

sol_orbiters = [cube, cube2, planet]
sol.orbit(sol_orbiters)

window.planets << sol 
window.planets << planet

window.physobjs << cube
window.physobjs << cube2
window.physobjs << planet

window.show
