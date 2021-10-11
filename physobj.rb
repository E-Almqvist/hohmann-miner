require "matrix"

class PhysObj
	attr_accessor :world, :pos, :vel, :accel, :x, :y
	def initialize(world)
		@world = world
		@pos = Vector.zero(2)
		@vel = Vector.zero(2)
		@accel = Vector.zero(2)
		@x, @y = 0, 0
	end

	def tick
		if( @accel.magnitude != 0 ) then
			@vel += @accel
		end

		if( @vel.magnitude != 0 ) then
			@pos += @vel
		end
		@x, @y = @pos[0], @pos[1]
	end

end


class PhysCube < PhysObj
	attr_reader :width, :height
	def initialize(world, width, height, color=0xff_ffffff, ela=-0.8)
		super world

		@width, @height = width, height
		@color = Gosu::Color.argb(color)
		@ela = ela
	end

	def render
		x, y = self.pos[0], self.pos[1]
		Gosu.draw_quad(x, y, @color, x + self.width, y, @color, x, y + self.height, @color, x + self.width, y + self.height, @color)
		self.draw_vector(@vel, 2)
	end

	def physics
		self.tick

		x, y = self.pos[0], self.pos[1]
		x_max = world.width - self.width
		y_max = world.height - self.height

		if( x > x_max ) then self.pos[0] = x_max end
		if( y > y_max ) then 
			self.pos[1] = y_max
			self.vel[1] = -2
			self.vel[0] = 1
		end

	end

	def draw_vector(vec, scale=0.1, color=0xaf_ffaaaa)
		clr = Gosu::Color.argb(color)
		dx, dy = vec[0], vec[1]
		xx, yy = @x + @width/2, @y + @height/2
		Gosu.draw_line(xx, yy, clr, (xx + dx).round(1) * scale, (yy + dy).round(1) * scale, clr)
		puts("#{dx} #{dy} #{[xx - (xx + dx), yy - (yy + dy)]}")
	end

end
