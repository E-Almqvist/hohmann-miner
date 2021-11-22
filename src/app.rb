#!/usr/bin/ruby -w

require "matrix"
require "gosu"

require_relative "utils/debug.rb"
require_relative "lib/gosu_plugin.rb"

require_relative "config.rb"

require_relative "lib/keyhook.rb"
require_relative "lib/ui.rb"
require_relative "lib/physobj.rb"
require_relative "lib/objects.rb"
require_relative "lib/controller.rb"
require_relative "lib/world.rb"

require_relative "ui/mainmenu.rb"

class Window < Gosu::Window
	attr_accessor :caption, :ui, :world, :mainmenu, :key_events
	attr_reader :width, :height, :fonts

	def initialize(title, width, height)
		super width, height
		@width, @height = width, height
		self.caption = "#{title}| #{width}x#{height}"

		# Key event queue
		@key_events = {
			up: [],
			down: []
		}

		# Keyhook for up releases
		@up_keyhook = KeyHook.new

		# Keyhook for down presses
		@down_keyhook = KeyHook.new

		@ui = []
		@fonts = {
			normal: Gosu::Font.new(self, MAIN_FONT, 18),
			big: Gosu::Font.new(self, MAIN_FONT, 20),
			title: Gosu::Font.new(self, MAIN_FONT, 64),
			button: Gosu::Font.new(self, MAIN_FONT, 48)
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

		sol_orbiters = [ply, cube2, planet]
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
		print "up: "
		p id

		# No queue needed for up keys
		@up_keyhook.call(KEY_EVENTS[id])
		@key_events[:down].delete(id) # when the key is released: stop holding it

#		if( @world && @world.controller ) then
#			@world.controller.button_up(id)
#		end
	end

	def button_down(id)
		super id
		print "down: "
		p id

		@key_events[:down] << id

#		if( id == BIND_PAUSE ) then
#			@freeze = !@freeze
#		end
#
#		if( @world && @world.controller ) then
#			@world.controller.button_down(id)
#		end
	end

	private def broadcast_event(event)
	end

	def update
		# Call all down key events each tick
		@key_events[:down].each do |keyid|
			@down_keyhook.call(KEY_EVENTS[keyid])
		end


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
# window.start_game
