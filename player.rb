require_relative("program")
require_relative("mash")

class Player
	attr_accessor :name
	attr_accessor :id
	attr_accessor :folder_path
	
	attr_accessor :total_scores
	attr_accessor :total_execution_time
	
	attr_accessor :nab
	attr_accessor :projectile
	attr_accessor :mash
	
	attr_accessor :results_file_path
	
	def initialize(pd_hash, programs_pth_hash)
		@id  = pd_hash[:id]
		@name = pd_hash[:name]
		@folder_path = pd_hash[:folder_path]
		@results_file_path = File.join( @folder_path, "results" )
		
		@total_scores = 0.0
		@total_execution_time = 0.0
		
		@nab = Program.new(self, Program_Type.new(programs_pth_hash[:nab]))
		@projectile = Program.new(self, Program_Type.new(programs_pth_hash[:projectile]))
		
		@mash = Mash.new(self)
	end
	
end


