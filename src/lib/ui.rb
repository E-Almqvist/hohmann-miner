class UI
	attr_accessor :x, :y
	attr_reader :window, :width, :height, :zindex, :uiscale
	def initialize(window, x, y, width, height, zindex=1, uiscale=1)
		@window = window
		@x, @y = x, y
		@width, @height = width, height
		@zindex = zindex
		@uiscale = uiscale

		@window.ui << self
	end

	private def pos
		Vector[@x, @y]
	end

	def color(color=0xff_ffffff)
		return Gosu::Color.argb(color)
	end

	def draw_text(string, font, x, y, z=0, color=0xff_ffffff, scale_x=1, scale_y=1)
		font.draw_text(string, self.x + x, self.y + y, self.zindex + z, scale_x, scale_y, self.color(color))
	end

	def draw_quad(vertex1, vertex2, vertex3, vertex4, z=0, mode=:default)
		Gosu.draw_quad(vertex1[0], vertex1[1], self.color(vertex1[2]), vertex2[0], vertex2[1], self.color(vertex2[2]), vertex3[0], vertex3[1], self.color(vertex3[2]), vertex4[0], vertex4[1], self.color(vertex4[2]), self.zindex + z, mode)
	end

	def draw_rect(x, y, width, height, color=0xff_ffffff, z=0, mode=:default)
		xx, yy = x + self.pos[0], y + self.pos[1]
		v1 = Vector[xx, yy, color] 
		v2 = Vector[width + xx, yy, color] 
		v3 = Vector[xx, height + yy, color] 
		v4 = Vector[width + xx, height + yy, color] 
		self.draw_quad(v1, v2, v3, v4, z, mode)
	end

	def draw_circle(x, y, r, c, z = 0, thickness = 1, sides = nil, mode = :default)
		Gosu::draw_circle(x, y, r, c, z, thickness, sides, mode)
	end
end

class Button < UI
	attr_accessor :selected, :menu, :colors
	attr_reader :text, :width, :height, :text_width, :text_height, :font, :zindex, :padding
	def initialize(window, menu, text, font, x=0, y=0, padding={x:32, y:2}, zindex=0)
		super window, x, y, width, height, zindex, menu.uiscale
		@menu = menu
		@font = font
		@zindex = zindex
		
		@text = text
		@text_width = @font.text_width(@text)
		@text_height = @font.height

		@padding = padding
		@width = @text_width + padding[:x]
		@height = @text_height + padding[:y]

		@selected = false
		@colors = {
			text: {
				selected: 0xff_ffeeee,
				default: 0xff_ff0000
			},
			background: {
				selected: 0xcc_cccccc,
				default: 0xaa_aaaaaa
			}
		}
	end

	def hover?
		inx = window.mouse_x >= self.x && window.mouse_x <= self.x + self.width + self.padding[:x]
		iny = window.mouse_y >= self.y && window.mouse_y <= self.y + self.height + self.padding[:y]
		# doing `n in (a..b).to....` is too slow
		# hence the ugly syntax above

		self.selected = inx && iny
	end

	def method_ptr=(self, new_ptr)
		# TODO: make a method pointer for button presses etc
	end

	def onclick(id, *args, **kwargs)
		self.method_ptr.call(id, *args, **kwargs)
	end

	def render
		sel = self.hover? ? :selected : :default
		self.draw_rect(0, 0, self.width, self.height, self.colors[:background][sel])

		self.draw_text(self.text, self.font, self.width/2 - self.text_width/2, self.height/2 - self.text_height/2, self.colors[:text][sel])
	end
end

class MainMenu < UI
	attr_accessor :show
	def initialize(window, show=false)
		super window, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 99
		@show = show
	end

	def render
		if( @show ) then
			self.draw_rect(0, 0, self.width, self.height, 0xaa_111015)

			titletext = "Hohmann Miner"
			titlewidth = self.window.fonts[:title].text_width(titletext)
			self.draw_text(titletext, self.window.fonts[:title], self.width/2 - titlewidth/2, self.height/4)

			playbtn = Button.new(self.window, self, "Play", self.window.fonts[:button])
			playbtn.x, playbtn.y = self.width/2 - playbtn.width/2, self.height/2 - playbtn.height/2
			playbtn.render

 			quitbtn = Button.new(self.window, self, "Quit", self.window.fonts[:button])
 			quitbtn.x, quitbtn.y = self.width/2 - quitbtn.width/2, quitbtn.height + playbtn.y + 16
 			quitbtn.render
		end
	end
end
