# World
WORLD_SEED = 123456789

# UI
WINDOW_WIDTH = 1600
WINDOW_HEIGHT = 900
WINDOW_FULLSCREEN = false
MAIN_FONT = "monospace"

# Keybinds
	# UI
	BIND_FIRE = Gosu::MS_LEFT
	BIND_FIRE2 = Gosu::MS_MIDDLE
	BIND_SELECT = Gosu::MS_RIGHT

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
	# General 
        general: {
                BIND_PAUSE => :pause,
                BIND_FIRE => :fire,
                BIND_SELECT => :select,
        },

	# Player Controlls 
        player: {
                BIND_TURN_LEFT => :turn_left,
                BIND_TURN_RIGHT => :turn_right,
                BIND_INCREASE_THRUST => :increase_thrust,
                BIND_DECREASE_THRUST => :decrease_thrust,
                BIND_TOGGLE_ENGINE => :toggle_engine
        }
}

