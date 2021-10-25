#!/usr/bin/ruby -w


require "matrix"
require "gosu"
require_relative "lib/gosu_plugin.rb"

require_relative "config.rb"

require_relative "lib/ui.rb"
require_relative "lib/physobj.rb"
require_relative "lib/objects.rb"
require_relative "lib/controller.rb"
require_relative "lib/world.rb"

class Window < Gosu::Window
	attr_accessor :caption, :ui, :world, :mainmenu
	attr_reader :width, :height, :fonts

	def initialize(title, width, height)
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		@world = nil 
		@ui = []
		@mainmenu = nil

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
		@world = World.new(WORLD_SEED, self)

		ply = Player.new("Player", self, 8, 8)
		ply.show_info = false 
		ply.thrust = 0.0075
		ply.pos = Vector[800, 450 + 500]
		ply.vel = Vector[1, 0]
		@world.controller = ply

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

		@world.planets << sol 
		@world.planets << planet

		@world.physobjs << ply 
		@world.physobjs << cube2
		@world.physobjs << planet

		@world.freeze = true
		self.mainmenu.show = false
	end

	def button_up(id)
		super id

		if( @world && @world.controller ) then
			@world.controller.button_up(id)
		end
	end

	def button_down(id)
		super id

		if( id == BIND_PAUSE ) then
			@freeze = !@freeze
		end

		if( @world && @world.controller ) then
			@world.controller.button_down(id)
		end
	end

	def button_up?(id)
		super id

		if( @world && @world.controller ) then
			@world.controller.button_up?(id)
		end
	end

	def button_down?(id)
		super id

		if( @world && @world.controller ) then
			@world.controller.button_down?(id)
		end
	end

	def update
		if( @world ) then
			@world.tick
		end
	end

	def draw
		@ui.each do |u|
			u.render
		end

		if( @world ) then
			@world.render
		end
	end
end


window = Window.new("Hohmann Miner", WINDOW_WIDTH, WINDOW_HEIGHT)
window.fullscreen = WINDOW_FULLSCREEN

window.mainmenu = MainMenu.new(window, true) 

window.show
