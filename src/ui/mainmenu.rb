def quit_game
	puts "QUIT"
end

class MainMenu < UI
	attr_accessor :show, :playbtn, :quitbtn
	
#	def quit_game
#		self.window.close!
#	end

	def initialize(window, show=false)
		super window, 0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 99
		@show = show

		@playbtn = Button.new(self.window, self, "Play", self.window.fonts[:button])
		@playbtn.add_event(:onclick, method(:quit_game))
		@playbtn.x, @playbtn.y = self.width/2 - @playbtn.width/2, self.height/2 - @playbtn.height/2

		@quitbtn = Button.new(self.window, self, "Quit", self.window.fonts[:button])
		@quitbtn.x, @quitbtn.y = self.width/2 - @quitbtn.width/2, @quitbtn.height + @playbtn.y + 16
		@quitbtn.create_method(:onclick) {
			@window.close
		}
	end


	def render
		if( @show ) then
			self.draw_rect(0, 0, self.width, self.height, 0xaa_111015)

			titletext = "Hohmann Miner"
			titlewidth = self.window.fonts[:title].text_width(titletext)
			self.draw_text(titletext, self.window.fonts[:title], self.width/2 - titlewidth/2, self.height/4)
			@playbtn.render
 			@quitbtn.render
		end
	end
end
