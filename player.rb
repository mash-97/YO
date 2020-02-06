require_relative("program")

class Player
	attr_accessor :name
	attr_accessor :id
	attr_accessor :folder_path
	
	attr_accessor :total_scores
	
	attr_accessor :nab
	attr_accessor :projectile
	attr_accessor :mash
	
	attr_accessor :results_file_path
	
	def initialize(pd, programs_pth_hash)
		@id  = pd[:id]
		@name = pd[:user_name]
		@folder_path = pd[:folder_path]
		@results_file_path = File.join( @folder_path, "results" )
		
		@total_scores = 0.0
		
		@nab = Program.new(self, Program_Type.new(programs_pth_hash[:nab]))
		@projectile = Program.new(self, Program_Type.new(programs_pth_hash[:projectile]))
		
		@mash = nil
	end
	
end


