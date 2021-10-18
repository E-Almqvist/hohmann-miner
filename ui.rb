class UI
	attr_accessor :x, :y
	attr_reader :width, :height, :zindex, :uiscale
	def initialize(x, y, width, height, zindex=1, uiscale=1)
		@x, @y = x, y
		@width, @height = width, height
		@zindex = zindex
		@uiscale = uiscale
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
		v1 = Vector[0, 0, color]
		v2 = Vector[width, 0, color]
		v3 = Vector[0, height, color]
		v4 = Vector[width, height, color]
		self.draw_quad(v1, v2, v3, v4, z, mode)
	end

end
