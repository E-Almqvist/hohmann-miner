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
end
