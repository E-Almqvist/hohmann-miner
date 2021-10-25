class Player < PhysCube
	attr_accessor :engine, :thrust
	def initialize(name, world, width, height, color=0xff_ffffff)
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
		case id

		when BIND_TOGGLE_ENGINE
			@engine = !@engine

		when BIND_TURN_LEFT
			self.angle -= 20

		when BIND_TURN_RIGHT
			self.angle += 20	

		when BIND_INCREASE_THRUST
			self.thrust += 0.0005
			self.thrust = self.thrust.round(5)

		when BIND_DECREASE_THRUST
			self.thrust -= 0.0005
			self.thrust = self.thrust.round(5)
		end
	end

	def button_down?(id)
	end

	def inspect
		return "\nName: #{self.name}\nOrbit of: #{self.parent_orbit.name}\nVel: #{self.vel.magnitude.round(1)} #{self.vel.round(4)}\nAccel: #{self.accel.magnitude.round(4)} #{self.accel.round(4)}\nPos: #{self.pos.round(4)}\nAngle: #{self.angle.round(1)} deg\nEngine: #{self.engine}\nThrust: #{self.thrust}\naccel_vecs: #{self.accel_vecs}\n"
	end
end
