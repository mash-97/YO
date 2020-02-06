require_relative("helper_classes")
require_relative("cprogram_generator")


class Mash
	MASH_PROGRAM = CProgram_Generator.new(".Test_Base/mash.cpp")
	MASH_FOLDER_NAME = "mash"
	MASH_PREF_FILE_PATH = "mash/.mash.pref"
	MASH_RESULTS_FILE_PATH = "mash/mash.results"
	MASH_ATTACKS_RESULTS_FILE_PATH = "mash/mash_attack.results"
	
	attr_accessor :owner
	attr_accessor :folder_path
	
	attr_accessor :mash_pref_file_path
	attr_accessor :mash_attacks
	
	attr_accessor :mash_results_file_path
	attr_accessor :mash_attacks_results_file_path
	
	
	def initialize(owner_obj)
		@owner = owner_obj
		
		@folder_path = File.join( @owner.folder_path, MASH_FOLDER_NAME )
		@mash_pref_file_path = File.join( @owner.folder_path, MASH_PREF_FILE_PATH )
		
		# keen out attack list from the @folder_path
		@mash_attacks = {}
		Dir.glob("#{@folder_path}/.*").each do |file_path|
			fbn = File.basename(file_path)
			@mash_attacks[fbn] =  file_path if (fbn=~/^\.\*$/ or fbn=~/^\.[0-9]+?$/)
		end
		
		@mash_results_file_path = File.join( @owner.folder_path, MASH_RESULTS_FILE_PATH )
		@mash_attacks_results_file_path = File.join( @owner.folder_path, MASH_ATTACKS_RESULTS_FILE_PATH )
		
	end
	
end

		
