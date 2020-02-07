require_relative("cprogram_generator")

class Program_Type
	TEST_BASE = ".Test_Base"
	attr_accessor :program_sym
	attr_accessor :program_name
	attr_accessor :time_limit
	
	attr_accessor :basecase_passcore
	attr_accessor :attack_dosscore
	
	attr_accessor :program_file_rgx
	
	attr_accessor :base_testcase_file_path
	attr_accessor :base_program_file_path
	
	attr_accessor :attacks_folder_name
	attr_accessor :folder_name
	
	
	attr_accessor :base_program
	
	def initialize(pthash)
		
		@program_name = pthash[:program_name]
		@program_sym = @program_name.to_sym
		@time_limit = pthash[:time_limit]
		@basecase_passcore = pthash[:basecase_passcore]
		@attack_dosscore = pthash[:attack_dosscore]
		
		@folder_name = pthash[:folder_name]
		@program_file_rgx = pthash[:program_file_rgx]
		@attacks_folder_name = pthash[:attacks_folder_name]
		
		@base_testcase_file_path = pthash[:base_testcase_file_path]
		@base_program = pthash[:base_program]
	end
end

