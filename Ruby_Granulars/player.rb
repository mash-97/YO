require_relative("program")
require_relative("mash")

class Player
	attr_accessor :name
	attr_accessor :id
	attr_accessor :folder_path
	
	attr_accessor :total_scores
	
	attr_accessor :programs
	attr_accessor :mash
	
	attr_accessor :message_box_file_path
	
	def initialize(pd_hash, programs_pth_hash)
		@id  = pd_hash[:id]
		@name = pd_hash[:name]
		@folder_path = pd_hash[:folder_path]
		@message_box_file_path = File.join( @folder_path, "messages_from_mash97")
		@results_file_path = File.join( @folder_path, "results" )
		 
		File.open(@message_box_file_path, "w").close()
			
		
		@total_scores = 0.0
		@total_execution_time = 0.0
		
		@programs = {}
		nab = Program.new(self, Program_Type.new(programs_pth_hash[:nab]))
		projectile = Program.new(self, Program_Type.new(programs_pth_hash[:projectile]))
		
		@programs = {:nab => nab, :projectile => projectile}
		@mash = Mash.new(self)
	end
	
	def sendMessage(message)
		file = File.open(@message_box_file_path, "a+")
		file.puts(message)
		file.close()
	end
	
end


