class Planet < PhysObj
	attr_reader :color, :mass, :radius, :circle_thickness
	def initialize(name, world, color, mass=1e+2, radius=20, circle_thickness=4)
		super name, world

		@color = color
		@mass = mass

		@radius = radius
		@circle_thickness = circle_thickness
	end

	def physics
		self.tick
	end

	private def calculate_gravity_scalar(obj, dir_vec)
		grav = GRAV_CONSTANT * (self.mass/(dir_vec.magnitude**2))
		return grav
	end

	private def calculate_gravity_vector(obj)
		dir_vec = self.pos - obj.pos + Vector[@radius/2, @radius/2]
		return (dir_vec/dir_vec.magnitude) * calculate_gravity_scalar(obj, dir_vec)  
	end

	def orbit(physobjs)
		physobjs.each do |obj|
			if( self != obj ) then
				grav_vec = self.calculate_gravity_vector(obj)
				obj.accel_vecs[self.name] = grav_vec
				obj.apply_accel_vecs
				obj.parent_orbit = self
			end
		end
	end

	# def inspect
	#	return "\n#{self.name}\nPos: #{self.pos.round(4)}\nMass: #{self.mass.round(4)}\nRadius: #{self.radius.round(4)} p\nGravity: #{(self.mass*GRAV_CONSTANT).round(2)} p/r^2"
	#end

	def render(x_offset=0, y_offset=0)
		super x_offset, y_offset, Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_circle(self.pos[0] + x_offset, self.pos[1] + y_offset, @radius, @color, 0, @circle_thickness)
	end

	def width
		return @radius
	end

	def height
		return @radius
	end
end

class PhysCube < PhysObj
	attr_reader :width, :height
	def initialize(name, world, width, height, color=0xff_ffffff)
		super name, world

		@width, @height = width, height
		@color = Gosu::Color.argb(color)
	end

	def render(offset_x=0, offset_y=0)
		super offset_x, offset_y, @color
		x, y = offset_x + self.pos[0], offset_y + self.pos[1]
		Gosu.draw_quad(x, y, @color, x + self.width, y, @color, x, y + self.height, @color, x + self.width, y + self.height, @color)
	end

	def physics
		self.tick
	end
end
