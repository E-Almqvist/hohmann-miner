require "matrix"

class PhysObj
	attr_accessor :world, :pos, :vel, :accel, :x, :y
	attr_reader :name
	def initialize(name, world)
		@name = name
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
	def initialize(name, world, width, height, color=0xff_ffffff, ela=-0.8)
		super name, world

		@width, @height = width, height
		@color = Gosu::Color.argb(color)
		@ela = ela
	end

	def render
		x, y = self.pos[0], self.pos[1]
		Gosu.draw_quad(x, y, @color, x + self.width, y, @color, x, y + self.height, @color, x + self.width, y + self.height, @color)
	end

	def physics
		self.tick

		x, y = self.pos[0], self.pos[1]
		x_max = world.width - self.width
		y_max = world.height - self.height

		if( x > x_max ) then 
			self.pos[0] = x_max 
			self.vel[0] = 0
		end
		if( y > y_max ) then 
			self.pos[1] = y_max
			self.vel[1] = 0
		end

	end

	def draw_vector(vec, scale=2, color=0xaf_ffaaaa)
		if( vec.magnitude != 0 ) then
			clr = Gosu::Color.argb(color)

			scaled_vec = vec*scale

			pos1 = self.pos + Vector[self.width/2, self.height/2]
			pos2 = pos1 + scaled_vec
			
			x1 = pos1[0]
			y1 = pos1[1]

			x2 = pos2[0]
			y2 = pos2[1]

			# Gosu.draw_line(x1, y1, clr, x2*scale, y2*scale, clr)
			Gosu.draw_line(x1, y1, clr, x2, y2, clr)

			puts("#{self.name}: pos1:#{pos1} pos2:#{pos2}")
		end
	end

end
