class World 
	attr_accessor :freeze, :physobjs, :planets, :controller, :camera
	def initialize(seed, window)
		@seed = seed
		@window = window

		@physobjs = []
		@planets = []

		@freeze = true 
		@controller = nil

		@camera = Vector[0, 0]
	end

	def tick
		if( !@freeze ) then
			@physobjs.each do |obj| 
				obj.physics 
			end

			@planets.each do |planet|
				orbiters = []
				orbiters += @physobjs
				orbiters += @planets
				orbiters.delete(planet)
				planet.orbit(planets)
			end
		end
	end

	def render
		if( @controller != nil ) then
			self.camera = Vector[self.width/2, self.height/2] - self.controller.pos 
			@font.draw_text(self.controller.debug_string, 0, 32, 1, 1.0, 1.0, Gosu::Color::WHITE)
		end
		camx, camy = self.camera[0], self.camera[1]

		@font2.draw_text("Frozen: #{@freeze}", 0, 0, 1, 1.0, 1.0, Gosu::Color::WHITE)

		@physobjs.each do |obj| 
			obj.render(camx, camy)
			obj.draw_vector(obj.vel, 10, 0xff_ffaaaaa, camx, camy)
			obj.draw_vector(obj.accel, 500, 0xff_aaffaa, camx, camy)
			obj.render_path(camx, camy)
			obj.draw_direction(camx, camy)
		end

		@planets.each do |planet|
			planet.render(camx, camy)
		end
	end
end
