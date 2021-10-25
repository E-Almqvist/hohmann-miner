#!/usr/bin/ruby -w
require "matrix"
require "gosu"
load "gosu_plugin.rb"

load "ui.rb"
load "config.rb"
load "physobj.rb"
load "objects.rb"
load "controller.rb"

class Window < Gosu::Window
	attr_accessor :caption, 
	attr_reader :width, :height, :fonts

	def initialize(title, width, height, universe)
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		#@physobjs = physobjs
		#@planets = planets
		@universe = universe

		@font = Gosu::Font.new(self, MAIN_FONT, 18)
		@font2 = Gosu::Font.new(self, MAIN_FONT, 20)
		@font_title = Gosu::Font.new(self, MAIN_FONT, 64)
		@font_button = Gosu::Font.new(self, MAIN_FONT, 48)

		@fonts = {
			normal: @font,
			big: @font2,
			title: @font_title,
			button: @font_button
		}

	end

	def start_game
		ply = Player.new("Player", self, 8, 8)
		ply.show_info = false 
		ply.thrust = 0.0075
		ply.pos = Vector[800, 450 + 500]
		ply.vel = Vector[1, 0]
		self.controller = ply

		cube2 = PhysCube.new("Beta", self, 8, 8)
		cube2.pos = Vector[800, 450 + 300]
		cube2.vel = Vector[2, 0]
		cube2.show_info = true

		sol = Planet.new("Sol", self, 0xff_ffffaa, 1e2, 15, 1)
		sol.pos = Vector[800, 450]

		planet = Planet.new("Planet", self, 0xff_cccccc, 1e1, 8, 1)
		planet.pos = Vector[800, 450 + 300]
		planet.vel = Vector[-2, 0]
		planet.show_info = true

		sol_orbiters = [cube, cube2, planet]
		sol.orbit(sol_orbiters)

		self.planets << sol 
		self.planets << planet

		self.physobjs << ply 
		self.physobjs << cube2
		self.physobjs << planet
	end

	def button_up(id)
		super id

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_up(id)
		end
	end

	def button_down(id)
		super id

		if( id == BIND_PAUSE ) then
			@freeze = !@freeze
		end

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_down(id)
		end
	end

	def button_up?(id)
		super id

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_up?(id)
		end
	end

	def button_down?(id)
		super id

		if( @controller != nil && @controller.class == Player ) then
			@controller.button_down?(id)
		end
	end

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
		@ui.each do |u|
			u.render
		end

		if( @controller != nil ) then
			@camera = Vector[self.width/2, self.height/2] - @controller.pos 
			@font.draw_text(@controller.debug_string, 0, 32, 1, 1.0, 1.0, Gosu::Color::WHITE)
		end
		camx, camy = @camera[0], @camera[1]

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


window = Window.new("Hohmann Miner", WINDOW_WIDTH, WINDOW_HEIGHT)
window.fullscreen = WINDOW_FULLSCREEN

mainmenu = MainMenu.new(window, true) 

window.show
