class Universe
	attr_accessor :freeze, :physobjs, :planets, :controller, :camera, :ui
	def initialize(seed, window)
		@seed = seed
		@window = window

		@physobjs = []
		@planets = []

		@freeze = true 
		@controller = nil

		@camera = Vector[0, 0]
		@ui = []
	end
end
