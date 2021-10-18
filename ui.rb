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

	def draw_text(string, font, x, y, z=0, scale_x=1, scale_y=1, color=0xff_ffffff)
		font.draw_text(string, self.x + x, self.y + y, self.zindex + z, scale_x, scale_y, color)
	end

	def draw_quad(vertex1, vertex2, vertex3, vertex4, z=0, mode=:default)
		Gosu.draw_quad(vertex1[0], vertex1[1], self.color(vertex1[2]), vertex2[0], vertex2[1], self.color(vertex2[2]), vertex3[0], vertex3[1], self.color(vertex3[2]), vertex4[0], vertex4[1], self.color(vertex4[2]), self.zindex + z, mode)
	end

	def draw_rect(x, y, width, height, color=0xff_ffffff, z=0, mode=:default)
		v1 = Vector[x, y, color] + self.pos 
		v2 = Vector[width + x, y, color] + self.pos 
		v3 = Vector[x, height + y, color] + self.pos 
		v4 = Vector[width + x, height + y, color] + self.pos 
		self.draw_quad(v1, v2, v3, v4, z, mode)
	end

	def draw_circle(x, y, r, c, z = 0, thickness = 1, sides = nil, mode = :default)
		Gosu::draw_circle(x, y, r, c, z, thickness, sides, mode)
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
			self.draw_rect(0, 0, self.width, self.height, 0x99_aaaaaa)
			self.draw_text("Hohmann Miner", self.window.fonts[:big], self.width/2, self.height/2)
		end
	end
end
