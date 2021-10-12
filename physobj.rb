require "matrix"
load "gosu_plugin.rb"

GRAV_CONSTANT = 1e+1

class PhysObj
	attr_accessor :world, :saved_pos, :pos, :vel, :accel, :x, :y, :show_info, :angle
	attr_reader :name
	def initialize(name, world)
		@name = name
		@world = world
		@pos = Vector.zero(2)
		@vel = Vector.zero(2)
		@accel = Vector.zero(2)
		@x, @y = 0, 0
		@saved_pos = []
		@show_info = false
		@angle = 0
	end

	def tick
		if( @accel.magnitude != 0 ) then
			@vel += @accel
		end

		if( @vel.magnitude != 0 ) then
			@pos += @vel
		end
		@x, @y = @pos[0], @pos[1]
		@angle %= 360
		@saved_pos << @pos
	end

	def render_path
		@saved_pos.each do |pos|
			Gosu.draw_rect(pos[0], pos[1], 1, 1, Gosu::Color.argb(0x44_ccccff))
		end
	end

	private def debug_string
		return "\n#{self.name}\nVel: #{self.vel.magnitude.round(1)} #{self.vel.round(4)}\nAccel: #{self.accel.magnitude.round(4)} #{self.accel.round(4)}\nPos: #{self.pos.round(4)}\nAngle: #{self.angle.round(1)} deg\n"
	end

	def render(x_offset=0, y_offset=0, color=Gosu::Color.argb(0xaa_2222ff))
		if( @show_info ) then
			self.world.fonts[:normal].draw(self.debug_string, self.pos[0] + x_offset, self.pos[1] + y_offset, 1, 1.0, 1.0, color)
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

			Gosu.draw_line(x1, y1, clr, x2, y2, clr)
		end
	end

	def draw_direction
		rads = (self.angle * Math::PI) / 180
		dir_vec = Vector[Math::cos(rads), Math::sin(rads)]
		self.draw_vector(dir_vec, 25, 0xaf_aaaaff)
	end
end


class PhysCube < PhysObj
	attr_reader :width, :height
	def initialize(name, world, width, height, color=0xff_ffffff)
		super name, world

		@width, @height = width, height
		@color = Gosu::Color.argb(color)
	end

	def render
		super 0, 0, @color
		x, y = self.pos[0], self.pos[1]
		Gosu.draw_quad(x, y, @color, x + self.width, y, @color, x, y + self.height, @color, x + self.width, y + self.height, @color)
	end

	def physics
		self.tick
	end
end


class Planet < PhysObj
	attr_reader :color, :mass, :radius, :circle_thickness
	def initialize(name, world, color, mass=1e+2, radius=20, circle_thickness=4)
		super name, world

		@color = color
		@mass = mass

		@radius = radius
		@circle_thickness = circle_thickness
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
			grav_vec = self.calculate_gravity_vector(obj)
			obj.accel = grav_vec
		end
	end

	private def debug_string
		return "\n#{self.name}\nPos: #{self.pos.round(4)}\nMass: #{self.mass.round(4)}\nRadius: #{self.radius.round(4)} p\nGravity: #{(self.mass*GRAV_CONSTANT).round(2)} p/r^2"
	end

	def render
		super @radius*3, @radius*3, Gosu::Color.argb(0xff_ffffff)
		Gosu.draw_circle(self.pos[0], self.pos[1], @radius, @color, 0, @circle_thickness)
	end
end


class Player < PhysCube
	attr_accessor :engine, :thrust
	def initialize(name, world, width, height, color=0xff_aaaaaa)
		super name, world, width, height, color

		@engine = false
		@thrust = 0.001
	end

	private def get_angle_vec
		rads = (self.angle * Math::PI) / 180
		dir_vec = Vector[Math::cos(rads), Math::sin(rads)]
		return dir_vec
	end

	def tick
		super

		if( @engine ) then
			self.vel += self.get_angle_vec * @thrust
		end
	end

	def button_up(id)
	end

	def button_up?(id)
	end

	def button_down(id)
		if( id == Gosu::KbSpace ) then
			@engine = !@engine
		end

		if( id == Gosu::KbLeft ) then
			self.angle -= 20
		end

		if( id == Gosu::KbRight ) then
			self.angle += 20	
		end
	end

	def button_down?(id)
	end

	private def debug_string
		return "\n#{self.name}\nVel: #{self.vel.magnitude.round(1)} #{self.vel.round(4)}\nAccel: #{self.accel.magnitude.round(4)} #{self.accel.round(4)}\nPos: #{self.pos.round(4)}\nAngle: #{self.angle.round(1)} deg\nEngine: #{self.engine}\nThrust: #{self.thrust}\n"
	end
end
