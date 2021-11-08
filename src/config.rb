# World
WORLD_SEED = 123456789

# UI
WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 900
WINDOW_FULLSCREEN = false
MAIN_FONT = "monospace"

# Keybinds
	# General
	BIND_PAUSE = Gosu::KbEscape

	# Player Controlls
	BIND_TURN_LEFT = Gosu::KbLeft
	BIND_TURN_RIGHT = Gosu::KbRight
	BIND_INCREASE_THRUST = Gosu::KbUp
	BIND_DECREASE_THRUST = Gosu::KbDown
	BIND_TOGGLE_ENGINE = Gosu::KbSpace

# Key events
KEY_EVENTS = {
	# UI
	BIND_PAUSE => :pause,

	# Player Controlls 
	BIND_TURN_LEFT => :turn_left,
	BIND_TURN_RIGHT => :turn_right,
	BIND_INCREASE_THRUST => :increase_thrust,
	BIND_DECREASE_THRUST => :decrease_thrust,
	BIND_TOGGLE_ENGINE => :toggle_engine
}

